{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.kde.enable;
  desktopCfg = config.modules.desktop.enable;
in
{
  options.modules.desktop.kde.enable = mkEnableOption "KDE Plasma desktop configuration";

  config = mkIf (cfg && desktopCfg) {
    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      # sddm 启用中文
      settings.General.GreeterEnvironment = "LANG=zh_CN.UTF-8,LANGUAGE=zh_CN:zh";
    };

    services.desktopManager.plasma6.enable = true;

    # fcitx5
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        waylandFrontend = true;

        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-rime
          kdePackages.fcitx5-qt
          kdePackages.fcitx5-configtool
          kdePackages.fcitx5-chinese-addons
          fcitx5-pinyin-zhwiki
        ];
      };
    };

    security.polkit.enable = true;

    environment.systemPackages = with pkgs; [
      pkgs.fcitx5-mellow-themes

      # 终端与字体
      ghostty
      nerd-fonts.jetbrains-mono

      # 剪贴板与基础工具
      wl-clipboard
      brightnessctl
      playerctl
      pavucontrol
      networkmanagerapplet

      # KDE 常用工具
      kdePackages.dolphin
      kdePackages.ark
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.partitionmanager

      # Dolphin 扩展
      kdePackages.kio-extras
      kdePackages.kio-fuse
      kdePackages.kimageformats
      kdePackages.kdegraphics-thumbnailers
      kdePackages.ffmpegthumbs
    ];

    # U 盘、移动硬盘等
    services.udisks2.enable = true;
  };
}
