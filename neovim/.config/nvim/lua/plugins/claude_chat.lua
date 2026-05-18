local function read_prompt(file)
  local config_dir = vim.fn.stdpath('config')
  local f = io.open(config_dir .. '/prompts/' .. file, 'r')
  if not f then return '' end
  local content = f:read('*all')
  f:close()
  return vim.trim(content)
end

-- ── window setup ──────────────────────────────────────────────────────────────

require('claude-chat').setup({
  split    = 'vsplit',
  position = 'left',
  width    = 0.5,
})

-- Monkey-patch start_claude_terminal to use termopen (list form).
-- This bypasses vim.cmd entirely so:
--   • newlines in prompts are preserved (no collapsing needed)
--   • % and # are NOT expanded as current/alternate filename
--   • no shell escaping issues
local window_mod  = require('claude-chat.window')
local config_mod  = require('claude-chat.config')
local state_mod   = require('claude-chat.state')
local keymaps_mod = require('claude-chat.keymaps')

-- Patch setup_file_watcher: remove the repeating timer.
-- The plugin's timer uses a local closure variable; when cleanup_timer() closes it
-- first, the still-queued vim.schedule_wrap callback tries to close it again →
-- "handle already closing" error. Keep only the autocmd-based checktime.
window_mod.setup_file_watcher = function()
  local s = state_mod.get()
  if not s.original_buf or not vim.api.nvim_buf_is_valid(s.original_buf) then return end
  state_mod.set_original_updatetime(vim.o.updatetime)
  vim.o.updatetime = 100
  vim.o.autoread   = true
  local grp = vim.api.nvim_create_augroup('ClaudeChatFileWatcher', { clear = true })
  vim.api.nvim_create_autocmd(
    { 'CursorHold', 'CursorHoldI', 'FocusGained', 'BufEnter' },
    { group = grp, callback = function() vim.cmd 'checktime' end }
  )
end

window_mod.start_claude_terminal = function(prompt)
  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_get_current_buf()
  state_mod.set_original_context(cur_win, cur_buf)

  window_mod.create_chat_window()

  local opts = config_mod.get()
  local cmd  = (prompt and prompt ~= '')
    and { opts.claude_cmd, prompt }
    or  { opts.claude_cmd }

  local win     = state_mod.get().win
  local new_buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_set_current_win(win)
  vim.api.nvim_win_set_buf(win, new_buf)

  local job_id = vim.fn.termopen(cmd)
  local buf    = vim.api.nvim_win_get_buf(win)

  state_mod.set_terminal_info(buf, win, job_id)
  vim.bo[buf].bufhidden = 'hide'
  vim.bo[buf].buflisted = false
  vim.wo[win].statusline = ' '
  vim.cmd 'stopinsert'

  keymaps_mod.setup_terminal_keymaps()
  window_mod.setup_file_watcher()
end

-- ── user commands ─────────────────────────────────────────────────────────────

local claude = require('claude-chat')

local prompts = {
  Explain  = 'Write an explanation for the selected code as paragraphs of text.',
  Review   = read_prompt('review.md'),
  Fix      = 'There is a problem in this code. Identify the issues and rewrite the code with fixes. Explain what was wrong and how your changes address the problems.',
  Optimize = 'Optimize the selected code to improve performance and readability. Explain your optimization strategy and the benefits of your changes.',
  Docs     = 'Please add documentation comments to the selected code.',
  Tests    = 'Please generate tests for my code.',
}

for name, prompt in pairs(prompts) do
  vim.api.nvim_create_user_command('ClaudeChat' .. name, function(opts)
    claude.ask_claude(prompt, opts.range, opts.line1, opts.line2)
  end, { range = true, desc = 'ClaudeChat: ' .. name })
end

-- Commit: cost-down via -p (non-interactive) + haiku (cheaper model).
-- Since -p has no agent/tool access, inject git context directly into the prompt.
local commit_prompt = read_prompt('commit.md')

local function build_commit_prompt()
  local parts = { commit_prompt }

  local diff = vim.fn.system('git diff --staged 2>/dev/null')
  if vim.v.shell_error == 0 and vim.trim(diff) ~= '' then
    parts[#parts + 1] = '\n\nStaged diff:\n```diff\n' .. vim.trim(diff) .. '\n```'
  end

  local git_dir = vim.trim(vim.fn.system('git rev-parse --git-dir 2>/dev/null'))
  if git_dir ~= '' then
    local f = io.open(git_dir .. '/COMMIT_EDITMSG', 'r')
    if f then
      local msg = vim.trim(f:read('*all'))
      f:close()
      if msg ~= '' then
        parts[#parts + 1] = '\n\nCurrent COMMIT_EDITMSG:\n```\n' .. msg .. '\n```'
      end
    end
  end

  return table.concat(parts)
end

-- Spinner float displayed over the terminal window while Claude is processing.
-- Closes automatically once terminal buffer has real content.
local function show_loading(term_buf, term_win)
  local spinner = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }
  local frame   = 1
  local label   = '  Thinking...  '
  local w       = #label + 2

  local fbuf = vim.api.nvim_create_buf(false, true)
  local fwin = vim.api.nvim_open_win(fbuf, false, {
    relative = 'win',
    win      = term_win,
    row      = math.floor(vim.api.nvim_win_get_height(term_win) / 2),
    col      = math.floor((vim.api.nvim_win_get_width(term_win) - w) / 2),
    width    = w,
    height   = 1,
    style    = 'minimal',
    border   = 'rounded',
    zindex   = 200,
  })
  vim.api.nvim_buf_set_lines(fbuf, 0, -1, false, { spinner[1] .. label })

  local timer = vim.loop.new_timer()
  local function stop()
    timer:stop()
    pcall(timer.close, timer)
    pcall(vim.api.nvim_win_close, fwin, true)
  end

  timer:start(0, 120, vim.schedule_wrap(function()
    if not vim.api.nvim_buf_is_valid(term_buf) then stop() return end
    for _, line in ipairs(vim.api.nvim_buf_get_lines(term_buf, 0, 5, false)) do
      if line ~= '' then stop() return end
    end
    frame = (frame % #spinner) + 1
    pcall(vim.api.nvim_buf_set_lines, fbuf, 0, -1, false, { spinner[frame] .. label })
  end))
end

vim.api.nvim_create_user_command('ClaudeChatCommit', function()
  if state_mod.is_session_active() then
    vim.notify('ClaudeChat: session already active', vim.log.levels.WARN)
    return
  end
  state_mod.set_original_context(
    vim.api.nvim_get_current_win(),
    vim.api.nvim_get_current_buf()
  )
  window_mod.create_chat_window()

  local win     = state_mod.get().win
  local new_buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_set_current_win(win)
  vim.api.nvim_win_set_buf(win, new_buf)

  local job_id = vim.fn.termopen({
    config_mod.get().claude_cmd,
    '--model', 'claude-haiku-4-5-20251001',
    '-p', build_commit_prompt(),
  })
  local buf = vim.api.nvim_win_get_buf(win)

  state_mod.set_terminal_info(buf, win, job_id)
  vim.bo[buf].bufhidden = 'hide'
  vim.bo[buf].buflisted = false
  vim.wo[win].statusline = ' '
  vim.cmd 'stopinsert'
  keymaps_mod.setup_terminal_keymaps()
  window_mod.setup_file_watcher()

  show_loading(buf, win)
end, { desc = 'ClaudeChat: Commit' })

-- ── <C-y>: extract commit message → write to COMMIT_EDITMSG ───────────────────

local commit_types = {
  'feat', 'fix', 'docs', 'style', 'refactor',
  'perf', 'test', 'build', 'ci', 'chore', 'revert',
}

local function is_claude_status(line)
  return line:find(' for %d+s') ~= nil or line:match('^> ') ~= nil
end

local function extract_commit_message(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- 1. prefer explicit ```gitcommit block
  local in_block, block = false, {}
  for _, line in ipairs(lines) do
    if line:match('^%s*```gitcommit') then
      in_block = true
    elseif line:match('^%s*```') and in_block then
      break
    elseif in_block then
      table.insert(block, line)
    end
  end
  if #block > 0 then return block end

  -- 2. find conventional-commit subject (ASCII find, safe for multibyte lines)
  local start_idx, subject
  for i, line in ipairs(lines) do
    for _, t in ipairs(commit_types) do
      local s = line:find(t .. '[!(:]')
      if s then
        start_idx = i
        subject   = line:sub(s)
        break
      end
    end
    if start_idx then break end
  end
  if not start_idx then return {} end

  local result = { subject }
  for i = start_idx + 1, #lines do
    if is_claude_status(lines[i]) then break end
    table.insert(result, lines[i])
  end
  -- remove any blank/whitespace-only lines immediately after subject
  while #result > 1 and result[2]:match('^%s*$') do
    table.remove(result, 2)
  end
  -- insert one clean empty line between subject and body
  if #result > 1 then
    table.insert(result, 2, '')
  end
  -- trim trailing blank lines
  while #result > 0 and result[#result]:match('^%s*$') do
    table.remove(result)
  end
  return result
end

local function find_commit_editmsg_buf()
  local s = state_mod.get()
  if s.original_buf and vim.api.nvim_buf_is_valid(s.original_buf) then
    if vim.api.nvim_buf_get_name(s.original_buf):match('COMMIT_EDITMSG$') then
      return s.original_buf
    end
  end
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(b):match('COMMIT_EDITMSG$') then
      return b
    end
  end
end

local function write_commit_to_editmsg(buf)
  local commit_lines = extract_commit_message(buf)
  if #commit_lines == 0 then
    vim.notify('ClaudeChat: commit message not found', vim.log.levels.WARN)
    return
  end
  local target = find_commit_editmsg_buf()
  if not target then
    vim.notify('ClaudeChat: COMMIT_EDITMSG buffer not found', vim.log.levels.WARN)
    return
  end
  if commit_lines[1] == '' then table.remove(commit_lines, 1) end
  vim.api.nvim_buf_set_lines(target, 0, -1, false, commit_lines)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == target then
      vim.api.nvim_set_current_win(win)
      break
    end
  end
  require('claude-chat').close_chat()
  vim.notify('ClaudeChat: commit message written', vim.log.levels.INFO)
end

-- ── setup_terminal_keymaps patch: add <C-y> and auto-scroll ───────────────────

local orig_setup_keymaps = keymaps_mod.setup_terminal_keymaps

keymaps_mod.setup_terminal_keymaps = function()
  orig_setup_keymaps()
  local buf = state_mod.get().buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end

  vim.api.nvim_buf_set_keymap(buf, 'n', '<C-y>', '', {
    callback = function() write_commit_to_editmsg(buf) end,
    noremap = true, silent = true,
    desc = 'Write commit message to COMMIT_EDITMSG',
  })

  -- auto-scroll to bottom when new output arrives
  vim.api.nvim_buf_attach(buf, false, {
    on_lines = function()
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then return end
        for _, win in ipairs(vim.fn.win_findbuf(buf)) do
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
          end
        end
      end)
    end,
  })
end

-- ── key mappings ──────────────────────────────────────────────────────────────

local function map(key, cmd, desc)
  vim.keymap.set('n', key, '<cmd>' .. cmd .. '<CR>', { desc = desc })
  vim.keymap.set('v', key, ":<C-u>'<,'>" .. cmd .. '<CR>', { desc = desc })
end

map('<leader>cc', 'ClaudeChat',         'Claude: Toggle')
map('<leader>ce', 'ClaudeChatExplain',  'Claude: Explain')
map('<leader>cr', 'ClaudeChatReview',   'Claude: Review')
map('<leader>cf', 'ClaudeChatFix',      'Claude: Fix')
map('<leader>co', 'ClaudeChatOptimize', 'Claude: Optimize')
map('<leader>cd', 'ClaudeChatDocs',     'Claude: Docs')
map('<leader>ct', 'ClaudeChatTests',    'Claude: Tests')
map('<leader>cC', 'ClaudeChatCommit',   'Claude: Commit')
