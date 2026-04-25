-- 平台识别模块。
-- 所有系统分支统一依赖这里的结果，
-- 不要在其他模块里重复解析 wezterm.target_triple。
return function(wezterm, utils)
  local triple = wezterm.target_triple or ""

  local is_win = utils.contains(triple, "windows")
  local is_linux = utils.contains(triple, "linux")
  local is_mac = utils.contains(triple, "apple")

  local os = "linux"
  if is_win then
    os = "windows"
  elseif is_mac then
    os = "mac"
  end

  return {
    os = os,
    is_win = is_win,
    is_linux = is_linux,
    is_mac = is_mac,
  }
end
