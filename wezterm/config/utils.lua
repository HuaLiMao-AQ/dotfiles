-- 通用工具函数模块。
-- 把字符串处理和标题格式化相关的小函数集中在这里，
-- 避免 platform / events / visual 之间相互依赖。
local M = {}

function M.contains(str, pattern)
  if not str or not pattern then
    return false
  end

  return string.find(str, pattern, 1, true) ~= nil
end

function M.is_found(str, pattern)
  return M.contains(str, pattern)
end

function M.basename(path)
  if not path or path == "" then
    return ""
  end

  local normalized = path:gsub("\\", "/")
  return normalized:match("([^/]+)$") or normalized
end

function M.first_token(text)
  if not text or text == "" then
    return ""
  end

  return text:match("^%s*([^%s]+)") or text
end

function M.first_word(command)
  return M.first_token(command)
end

function M.clean_title(title)
  if not title or title == "" then
    return ""
  end

  return title:gsub("^%s+", ""):gsub("%s+$", "")
end

function M.basename_from_uri_or_path(value)
  if not value then
    return ""
  end

  if type(value) == "table" and value.file_path then
    return M.basename(value.file_path)
  end

  local text = tostring(value)
  local path = text:match("^file://[^/]+(.+)$")
  if path and path ~= "" then
    return M.basename(path)
  end

  return M.basename(text)
end

function M.format_cmd_cwd(cmd, cwd)
  cmd = M.clean_title(cmd)
  cwd = M.clean_title(cwd)

  if cmd ~= "" and cwd ~= "" then
    return cmd .. " · " .. cwd
  end

  if cmd ~= "" then
    return cmd
  end

  if cwd ~= "" then
    return cwd
  end

  return "shell"
end

function M.title_from_user_vars(user_vars)
  if type(user_vars) ~= "table" then
    return ""
  end

  local cmd = M.clean_title(user_vars.WEZTERM_PROG_BASENAME or user_vars.WEZTERM_SHELL or "")
  local cwd = M.clean_title(user_vars.WEZTERM_CWD_BASENAME or "")
  return M.format_cmd_cwd(cmd, cwd)
end

return M
