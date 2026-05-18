local function read_copilot_prompt(file)
  -- Get the current Neovim configuration directory
  local config_dir = vim.fn.stdpath('config')

  -- Directory containing the .md files
  local prompt_directory = config_dir .. '/prompts'
  local prompt_file = prompt_directory .. '/' .. file
  local f = io.open(prompt_file, 'r')
  local prompts = ""
  if f then
    local content = f:read('*all')
    prompts = content
    f:close()
  else
    prompts = ""
  end
  return prompts
end

require("CopilotChat").setup {
  -- Shared config starts here (can be passed to functions at runtime and configured via setup function)

  system_prompt = 'COPILOT_INSTRUCTIONS', -- System prompt to use (can be specified manually in prompt via /).

  model = 'gpt-5.4-mini', -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
  agent = 'copilot', -- Default agent to use, see ':CopilotChatAgents' for available agents (can be specified manually in prompt via @).
  context = nil, -- Default context or array of contexts to use (can be specified manually in prompt via #).
  sticky = nil, -- Default sticky prompt or array of sticky prompts to use at start of every new chat.

  temperature = 0.1, -- GPT result temperature
  headless = false, -- Do not write to chat buffer and use history (useful for using custom processing)
  stream = nil, -- Function called when receiving stream updates (returned string is appended to the chat buffer)
  callback = nil, -- Function called when full response is received (retuned string is stored to history)
  remember_as_sticky = true, -- Remember model/agent/context as sticky prompts when asking questions

  -- default window options
  window = {
    layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
    width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
    height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
    -- Options below only apply to floating windows
    relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
    border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
    row = nil, -- row position of the window, default is centered
    col = nil, -- column position of the window, default is centered
    title = 'Copilot Chat', -- title of chat window
    footer = nil, -- footer of chat window
    zindex = 1, -- determines if window is on top or below other floating windows
  },

  show_help = true, -- Shows help message as virtual lines when waiting for user input
  highlight_selection = true, -- Highlight selection
  highlight_headers = true, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)
  references_display = 'virtual', -- 'virtual', 'write', Display references in chat as virtual text or write to buffer
  auto_follow_cursor = true, -- Auto-follow cursor in chat
  auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
  insert_at_end = false, -- Move cursor to end of buffer when inserting text
  clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

  -- Static config starts here (can be configured only via setup function)

  debug = false, -- Enable debug logging (same as 'log_level = 'debug')
  log_level = 'info', -- Log level to use, 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
  proxy = nil, -- [protocol://]host[:port] Use this proxy
  allow_insecure = false, -- Allow insecure server connections

  chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)

  log_path = vim.fn.stdpath('state') .. '/CopilotChat.log', -- Default path to log file
  history_path = vim.fn.stdpath('data') .. '/copilotchat_history', -- Default path to stored history

  question_header = '# User ', -- Header to use for user questions
  answer_header = '# Copilot ', -- Header to use for AI answers
  error_header = '# Error ', -- Header to use for errors
  separator = '───', -- Separator to use in chat

  -- default providers
  -- see config/providers.lua for implementation
  providers = {
    copilot = {
    },
    github_models = {
    },
    copilot_embeddings = {
    },
  },

  -- default functions
  -- see config/functions.lua for implementation
  functions = {
    commit_editmsg = {
      description = 'Content of .git/COMMIT_EDITMSG',
      resolve = function()
        local git_dir = vim.fn.trim(vim.fn.system('git rev-parse --absolute-git-dir 2>/dev/null'))
        if git_dir == '' then return {} end
        local path = git_dir .. '/COMMIT_EDITMSG'
        local f = io.open(path, 'r')
        if not f then return {} end
        local content = f:read('*all')
        f:close()
        if content == '' then return {} end
        return {
          {
            uri = 'file://' .. path,
            name = 'COMMIT_EDITMSG',
            mimetype = 'text/plain',
            data = content,
          }
        }
      end,
    },
  },

  -- default prompts
  -- see config/prompts.lua for implementation
  prompts = {
    Explain = {
      prompt = 'Write an explanation for the selected code as paragraphs of text.',
      system_prompt = 'COPILOT_EXPLAIN',
    },
    Review = {
      prompt = '> /COPILOT_REVIEW\n\n' .. read_copilot_prompt('review.md'),
      system_prompt = 'COPILOT_REVIEW',
      context = {'buffer', 'gitdiff:staged'},
    },
    Fix = {
      prompt = 'There is a problem in this code. Identify the issues and rewrite the code with fixes. Explain what was wrong and how your changes address the problems.',
    },
    Optimize = {
      prompt = 'Optimize the selected code to improve performance and readability. Explain your optimization strategy and the benefits of your changes.',
    },
    Docs = {
      prompt = 'Please add documentation comments to the selected code.',
    },
    Tests = {
      prompt = 'Please generate tests for my code.',
    },
    Commit = {
      prompt = read_copilot_prompt('commit.md'),
      resources = {'gitdiff:staged', 'buffer', 'commit_editmsg'},
    },
  },

  -- default mappings
  -- see config/mappings.lua for implementation
  mappings = {
    complete = {
      normal = '<Tab>',
      insert = '<Tab>',
    },
    close = {
      normal = 'q',
      insert = '<C-c>',
    },
    reset = {
      normal = '<C-l>',
      insert = '<C-l>',
    },
    submit_prompt = {
      normal = '<CR>',
      insert = '<C-s>',
    },
    toggle_sticky = {
      normal = 'grr',
    },
    clear_stickies = {
      normal = 'grx',
    },
    accept_diff = {
      normal = '<C-y>',
      insert = '<C-y>',
    },
    jump_to_diff = {
      normal = 'gj',
    },
    quickfix_answers = {
      normal = 'gqa',
    },
    quickfix_diffs = {
      normal = 'gqd',
    },
    yank_diff = {
      normal = 'gy',
      register = '"', -- Default register to use for yanking
    },
    show_diff = {
      normal = 'gd',
      full_diff = false, -- Show full diff instead of unified diff when showing diff window
    },
    show_info = {
      normal = 'gi',
    },
    show_context = {
      normal = 'gc',
    },
    show_help = {
      normal = 'gh',
    },
  },
}

-- 全局：所有 copilot-chat buffer 開啟時自動掛上 scroll
local _chat_scroll_attached = {}
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'copilot-chat',
  callback = function(ev)
    local buf = ev.buf
    if _chat_scroll_attached[buf] then return end
    _chat_scroll_attached[buf] = true
    vim.api.nvim_buf_attach(buf, false, {
      on_lines = function()
        vim.schedule(function()
          for _, win in ipairs(vim.fn.win_findbuf(buf)) do
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_set_cursor(win, {vim.api.nvim_buf_line_count(buf), 0})
            end
          end
        end)
      end,
    })
  end,
})

vim.api.nvim_create_user_command('GenerateCommitMessage', function()
    local origin_win = vim.api.nvim_get_current_win()

    require('CopilotChat').ask('/Commit', {
      prompt = read_copilot_prompt('commit.md'),
      model = 'gpt-5.4-mini',
      resources = {'gitdiff:staged', 'buffer', 'commit_editmsg'},
      callback = function(response)
         require('plenary.async').run(function()
          require('CopilotChat').close()
         end)

        local row, col = unpack(vim.api.nvim_win_get_cursor(origin_win))
        -- 只抓取 gitcommit 代碼區塊
        local pattern = "```gitcommit(.-)```"
        local body = response:match(pattern)

        -- 將內容轉換為行
        local lines = require('plugins.utils').split(body, '\n')

        -- 加入空白行
        table.insert(lines, 2, '')
        table.insert(lines, '')

        vim.api.nvim_buf_set_text(
          vim.api.nvim_win_get_buf(origin_win),
          row - 1, col, row, col,
          lines
        )

        return response
      end,
    })
  end, {})


