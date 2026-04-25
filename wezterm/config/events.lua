-- WezTerm 事件处理模块。
-- 标题优先使用 shell 通过 OSC 2 主动上报的内容；
-- 如果 shell 没有提供标题，再回退到前台进程名。
return function(config, wezterm, platform, colors, utils)
  local function fallback_title(pane)
    local cmd = utils.basename(pane.foreground_process_name or "")
    if cmd == "" or cmd == "wezterm" then
      cmd = "zsh"
    end

    local cwd = utils.basename_from_uri_or_path(
      pane:get_current_working_dir() or pane.current_working_dir
    )
    return utils.format_cmd_cwd(cmd, cwd)
  end

  wezterm.on("format-window-title", function(tab, pane, tabs, panes, effective_config)
    local user_title = utils.title_from_user_vars(pane:get_user_vars())
    if user_title ~= "" and user_title ~= "wezterm" then
      return user_title
    end

    local title = utils.clean_title(pane:get_title() or pane.title or "")

    -- 次选路径：zsh hook 主动发送 `cmd · cwd` 形式的标题。
    if title ~= "" and title ~= "wezterm" then
      return title
    end

    return fallback_title(pane)
  end)

  wezterm.on("format-tab-title", function(tab, tabs, panes, effective_config, hover, max_width)
    local pane = tab.active_pane
    local user_title = utils.title_from_user_vars(pane:get_user_vars())
    if user_title ~= "" and user_title ~= "wezterm" then
      return user_title
    end

    local title = utils.clean_title(pane:get_title() or pane.title or "")

    if title ~= "" and title ~= "wezterm" then
      return title
    end

    return fallback_title(pane)
  end)
end
