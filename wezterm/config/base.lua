-- 跨平台基础行为配置。
-- 这里负责字体、铃声、窗口初始尺寸等默认层，
-- 平台相关视觉差异会在 visual 模块中继续补充。
return function(config, wezterm, platform, colors, utils)
  -- 开启自动重载，关闭更新提示，减少日常干扰。
  config.automatically_reload_config = true
  config.check_for_updates = false
  config.show_update_window = false

  -- 关闭声音铃声，只保留较轻的视觉反馈。
  config.audible_bell = "Disabled"
  config.visual_bell = {
    fade_in_duration_ms = 60,
    fade_out_duration_ms = 80,
    fade_in_function = "EaseIn",
    fade_out_function = "EaseOut",
  }

  colors.apply(config)

  -- JetBrains Mono 作为主字体，后备字体负责补齐 Nerd Font 图标。
  config.font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
    "JetBrains Mono",
    "Symbols Nerd Font Mono",
  })

  -- macOS 默认字号略大，Linux / Windows 稍小一些。
  config.font_size = platform.is_mac and 14.0 or 12.5
  config.line_height = 1.08
  config.cell_width = 1.0

  -- 初始窗口留出足够宽度，更适合开发场景。
  config.initial_cols = 120
  config.initial_rows = 32
  config.scrollback_lines = 8000

  -- 保持缩放、窗口尺寸和鼠标行为在各平台尽量一致。
  config.adjust_window_size_when_changing_font_size = false
  config.use_resize_increments = true
  config.hide_mouse_cursor_when_typing = true

  -- 在现代 Linux 桌面环境下优先使用原生 Wayland。
  config.enable_wayland = true

  -- macOS 使用原生全屏行为，更符合系统习惯。
  config.native_macos_fullscreen_mode = true
end
