/**
  tmux 配置文件
*/
{
  lib,
  config,
  ...
}:

with lib;

{
  options.modules.tmux.enable = mkEnableOption "tmux";

  config = mkIf config.modules.tmux.enable {
    programs.tmux = {
      enable = true;

      # 鼠标滚轮、点击切换窗格、拖动调整大小
      mouse = true;

      # 保存 10 万行终端历史
      historyLimit = 100000;

      # 使用 vi 风格的历史查看快捷键
      keyMode = "vi";

      # 降低 Esc 延迟
      escapeTime = 0;

      # tmux 启动时创建或复用默认会话
      newSession = true;

      extraConfig = ''
        # 窗口、面板从 1 开始编号
        set -g base-index 1
        setw -g pane-base-index 1
        set -g renumber-windows on

        # SSH 断开后没有客户端时仍保留 session
        set -g exit-empty off

        # 窗格中的程序退出后不保留空窗格
        set -g remain-on-exit off

        # 状态刷新频率
        set -g status-interval 5

        # 允许终端程序使用鼠标
        set -g mouse on
      '';
    };
  };
}
