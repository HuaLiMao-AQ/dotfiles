-- 终端统一配色中心。
-- 这里改用你本机 iTerm2 默认 profile（Default）的 Dark 分支颜色值，
-- 让 WezTerm 的观感更接近 iTerm2 默认深色模式。
return function(wezterm, platform, utils)
  local palette = {
    -- 来自 iTerm2 默认 profile 的深色背景、前景和强调色。
    background = "#1e1f29",
    background_dark = "#181922",
    foreground = "#e6e6e6",
    foreground_dim = "#bbbbbb",
    accent = "#bd93f9",
    ansi = {
      "#000000",
      "#ff5555",
      "#50fa7b",
      "#f1fa8c",
      "#bd93f9",
      "#ff79c6",
      "#8be9fd",
      "#bbbbbb",
    },
    brights = {
      "#555555",
      "#ff5555",
      "#50fa7b",
      "#f1fa8c",
      "#bd93f9",
      "#ff79c6",
      "#8be9fd",
      "#ffffff",
    },
  }

  -- 顶部区域和终端主体背景保持一致，形成沉浸式一体感。
  palette.tab_bar = {
    background = palette.background,
    active_tab = {
      bg_color = palette.background,
      fg_color = palette.foreground,
    },
    inactive_tab = {
      bg_color = palette.background,
      fg_color = palette.foreground_dim,
    },
    inactive_tab_hover = {
      bg_color = palette.background,
      fg_color = palette.foreground,
    },
    new_tab = {
      bg_color = palette.background,
      fg_color = palette.foreground_dim,
    },
    new_tab_hover = {
      bg_color = palette.background,
      fg_color = palette.foreground,
    },
  }

  -- 导出给 WezTerm 直接使用的配色表。
  palette.scheme = {
    foreground = palette.foreground,
    background = palette.background,
    cursor_bg = "#bbbbbb",
    cursor_fg = "#ffffff",
    cursor_border = "#bbbbbb",
    selection_bg = "#44475a",
    selection_fg = palette.foreground,
    scrollbar_thumb = "#44475a",
    split = "#44475a",
    ansi = palette.ansi,
    brights = palette.brights,
    tab_bar = palette.tab_bar,
  }

  function palette.apply(config)
    config.colors = palette.scheme
  end

  return palette
end
