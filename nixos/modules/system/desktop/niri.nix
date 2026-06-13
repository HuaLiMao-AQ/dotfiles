{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.niri.enable;
  desktopCfg = config.modules.desktop.enable;
in
{
  options.modules.desktop.niri.enable = mkEnableOption "Niri configure";

  config = mkIf (cfg && desktopCfg) {
    programs.niri = {
      enable = true;
      useNautilus = false;
    };

    environment.systemPackages = with pkgs; [
      # 终端
      ghostty
      nerd-fonts.jetbrains-mono

      # 桌面基础组件
      waybar # 状态栏
      fuzzel # 应用启动器
      mako # 通知中心
      swaylock # 锁屏
      swayidle # 空闲、自动锁屏
      swaybg # 简单壁纸

      # X11 应用兼容
      xwayland-satellite

      # Polkit 图形认证代理
      kdePackages.polkit-kde-agent-1

      # 剪贴板
      wl-clipboard

      # 音量、亮度、媒体控制
      brightnessctl
      playerctl
      pavucontrol

      # NetworkManager 托盘
      networkmanagerapplet

      # KDE 文件管理器
      kdePackages.dolphin
      kdePackages.ark

      # Dolphin 扩展
      kdePackages.kio-extras
      kdePackages.kio-fuse
      kdePackages.kimageformats
      kdePackages.kdegraphics-thumbnailers
      kdePackages.ffmpegthumbs

    ];

    # 使 swaylock 可以校验当前用户密码
    security.pam.services.swaylock = { };

    # U 盘、移动硬盘等
    services.udisks2.enable = true;
  };
}
