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

  sddmThemeName = "sddm-astronaut-theme";

  sddmTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
  };
in
{
  options.modules.desktop.niri.enable = mkEnableOption "Niri configure";

  config = mkIf (cfg && desktopCfg) {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      theme = sddmThemeName;

      extraPackages = [
        sddmTheme
      ];

      # sddm 启用中文
      settings.General.GreeterEnvironment = "LANG=zh_CN.UTF-8,LANGUAGE=zh_CN:zh";
    };

    programs.niri = {
      enable = true;
      useNautilus = false;
    };

    # fcitx5
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        waylandFrontend = true;

        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-rime
          qt6Packages.fcitx5-configtool
          qt6Packages.fcitx5-chinese-addons
        ];
      };
    };

    security.polkit.enable = true;

    environment.systemPackages = with pkgs; [
      pkgs.fcitx5-mellow-themes

      # 终端
      sddmTheme
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
