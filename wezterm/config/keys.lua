-- 快捷键配置层。
-- 目标是在 macOS 上尽量贴近 iTerm2 / Command 习惯，
-- 同时让 Linux / Windows 也保留顺手的兼容键位。
return function(config, wezterm, platform, colors, utils)
  local act = wezterm.action
  local keys = {}

  -- macOS 使用 Super(Command)；其他平台默认使用 Ctrl+Shift。
  local primary_mod = platform.is_mac and "SUPER" or "CTRL|SHIFT"
  -- Windows 额外保留一套 Super 快捷键，增强原生感。
  local compatibility_mod = platform.is_win and "SUPER" or nil

  local function add_binding(key, mods, action)
    table.insert(keys, {
      key = key,
      mods = mods,
      action = action,
    })

    if compatibility_mod and mods == primary_mod then
      table.insert(keys, {
        key = key,
        mods = compatibility_mod,
        action = action,
      })
    end
  end

  -- 核心操作：标签页、分屏、全屏、字号调整。
  add_binding("t", primary_mod, act.SpawnTab("CurrentPaneDomain"))
  add_binding("w", primary_mod, act.CloseCurrentPane({ confirm = true }))
  add_binding("d", primary_mod, act.SplitHorizontal({ domain = "CurrentPaneDomain" }))
  add_binding("d", primary_mod .. "|SHIFT", act.SplitVertical({ domain = "CurrentPaneDomain" }))
  add_binding("Enter", primary_mod, act.ToggleFullScreen)
  add_binding("=", primary_mod, act.IncreaseFontSize)
  add_binding("-", primary_mod, act.DecreaseFontSize)
  add_binding("0", primary_mod, act.ResetFontSize)

  add_binding("c", primary_mod, act.CopyTo("Clipboard"))
  add_binding("v", primary_mod, act.PasteFrom("Clipboard"))
  add_binding("f", primary_mod, act.Search("CurrentSelectionOrEmptyString"))
  add_binding("r", primary_mod .. "|SHIFT", act.ReloadConfiguration)

  -- 标签页切换延续 iTerm2 常见的数字键习惯。
  for i = 1, 9 do
    add_binding(tostring(i), primary_mod, act.ActivateTab(i - 1))
  end

  config.keys = keys
end
