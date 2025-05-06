local utils = {}

utils.get_current_selection = function()
  local _, start_line, start_column, end_line, end_column
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' or mode == '' then
    -- if we are in visual mode use the live position
    _, start_line, start_column, _ = unpack(vim.fn.getpos('.'))
    _, end_line, end_column, _ = unpack(vim.fn.getpos('v'))

    if mode == 'V' then
      -- visual line doesn't provide columns
      if end_line < start_line then start_line, end_line = end_line, start_line end
      end_column = #vim.fn.getline(end_line, end_line)[1]
    end
  else
    -- otherwise, use the last known visual position
    _, start_line, start_column, _ = unpack(vim.fn.getpos("'<"))
    _, end_line, end_column, _ = unpack(vim.fn.getpos("'>"))
  end

  if end_line < start_line then start_line, end_line = end_line, start_line end
  if end_column < start_column then start_column, end_column = end_column, start_column end

  return start_line, start_column, end_line, end_column
end

utils.get_current_selection_text = function()
  local start_line, start_column, end_line, end_column = utils.get_current_selection()
  local lines = vim.fn.getline(start_line, end_line)
  local n = #lines

  if n <= 0 then
    return ''
  end

  lines[n] = string.sub(lines[n], 1, end_column)
  lines[1] = string.sub(lines[1], start_column)

  return table.concat(lines, '\n')
end

---@param t table
utils.except = function(t, except)
  local result = {}

  for _, value in ipairs(t) do
    if value ~= except then
      table.insert(result, value)
    end
  end

  return result
end

---@param t table
utils.in_table = function(t, value)
  for _, v in ipairs(t) do
    if v == value then
      return true
    end
  end

  return false
end

---@param t table
utils.unique = function(t)
  local result = {}

  for _, value in ipairs(t) do
    if not utils.intable(result, value) then
      table.insert(result, value)
    end
  end

  return result
end

---@param t1 table
---@param t2 table
utils.merge = function(t1, t2)
  local result = {}

  for key, value in ipairs(t1) do
    result[key] = value
  end

  for key, value in ipairs(t2) do
    result[key] = value
  end

  return result
end

---@param t table
utils.map = function(t, callback)
  local result = {}

  for key, value in ipairs(t) do
    result[key] = callback(value)
  end

  return result
end

---@param t table
utils.filter = function(t, callback)
  local result = {}

  for key, value in ipairs(t) do
    if callback(value) then
      result[key] = value
    end
  end

  return result
end

---@param t table
utils.entities_and_dictionary = function(t)
  local keys = {}
  local values = {}
  local dictionary = {}

  for language, list in pairs(t) do
    table.insert(keys, language)

    if type(list) ~= 'table' then
      list = { list }
    end

    for _, value in ipairs(list) do
      if not utils.in_table(values, value) then
        table.insert(values, value)
        dictionary[value] = language
      end
    end
  end

  return keys, values, dictionary
end

utils.file_exists = function(path)
  local file = io.open(path, 'r')

  if file == nil then
    return false
  end

  io.close(file)

  return true
end

utils.mod_exists = function(modname)
  return utils.file_exists(vim.fn.stdpath('config')..'/lua/'..modname:gsub('%.', '/')..'.lua')
end

utils.require_if_exists = function(modname)
  if utils.mod_exists(modname) then
    return require(modname)
  end
end

utils.set_option_value = function(key, value)
  vim.api.nvim_set_option_value(key, value, { buf = 0 })
end

utils.language = function(language, callback)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = language,
    group = vim.api.nvim_create_augroup(language, { clear = true }),
    callback = callback,
  })
end

utils.split = function(str, sep)
  local result = {}

  if str == nil or str == '' then
    table.insert(result, '')
    return result
  end

  for value in string.gmatch(str, '([^'..sep..']+)') do
    table.insert(result, value)
  end

  return result
end

return utils
