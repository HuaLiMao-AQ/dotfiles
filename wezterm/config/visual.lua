-- 视觉样式和窗口外观配置。
-- 这里改用系统标题栏路线，让窗口按钮回归系统标题栏，
-- 同时彻底隐藏 tab 栏，更接近 iTerm2 的原生窗口观感。
return function(config, wezterm, platform, colors, utils)
  local decorations = "TITLE|RESIZE"

  -- 这条路线不再依赖 integrated buttons，因此可以直接隐藏 tab 栏。
  config.enable_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true
  config.show_tabs_in_tab_bar = false
  config.show_new_tab_button_in_tab_bar = false
  config.show_tab_index_in_tab_bar = false
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = false

  -- 使用系统标题栏，保留原生窗口按钮与拖拽行为。
  config.window_decorations = decorations

  -- 顶部 padding 收紧，让内容区更贴近标题栏。
  config.window_padding = {
    left = 12,
    right = 12,
    top = 8,
    bottom = 10,
  }

  -- 系统标题栏尽量与内容区背景保持一致，减少分层感。
  config.window_frame = {
    active_titlebar_bg = colors.background,
    inactive_titlebar_bg = colors.background,
    active_titlebar_fg = colors.foreground,
    inactive_titlebar_fg = colors.foreground_dim,
    active_titlebar_border_bottom = colors.background,
    inactive_titlebar_border_bottom = colors.background,
    button_fg = colors.foreground_dim,
    button_bg = colors.background,
    button_hover_fg = colors.foreground,
    button_hover_bg = colors.background_dark,
    font = wezterm.font_with_fallback({
      "JetBrainsMono Nerd Font",
      "JetBrains Mono",
      "Symbols Nerd Font Mono",
    }),
    font_size = platform.is_mac and 12.0 or 11.0,
  }

  -- 非激活 pane 只做轻微变暗，避免过重遮罩。
  config.inactive_pane_hsb = {
    saturation = 0.92,
    brightness = 0.78,
  }

  -- 即便窗口半透明，文本背景也保持不透明，确保字形清晰。
  config.text_background_opacity = 1.0

  if platform.is_mac then
    -- macOS 适当降低透明和 blur 强度，减弱系统合成造成的浅色外边缘。
    config.window_background_opacity = 0.8
    config.macos_window_background_blur = 15
  else
    -- Linux 默认使用适中的半透明；KDE Wayland blur 仍以 nightly 为主。
    config.window_background_opacity = 0.92
    -- KDE Wayland blur 可能仅在 WezTerm nightly 可用。
    -- 如果你在使用 nightly，可以取消下面这行注释：
    -- config.kde_window_background_blur = true

    if platform.is_win then
      -- Windows 的 Mica / Acrylic 更适合搭配完全透明的窗口填充。
      config.window_background_opacity = 0
      config.win32_system_backdrop = "Mica"
      -- 如果你想要更强的毛玻璃效果，可改成：
      -- config.win32_system_backdrop = "Acrylic"
    else
      config.enable_wayland = true
    end
  end
end
