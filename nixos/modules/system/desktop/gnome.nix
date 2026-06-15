{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.gnome.enable;
  desktopCfg = config.modules.desktop.enable;
in
{
  options.modules.desktop.gnome.enable = mkEnableOption "GNOME desktop configuration";

  config = mkIf (cfg && desktopCfg) {
    services.xserver.enable = true;

    services.displayManager.gdm = {
      enable = true;
    };
    services.desktopManager.gnome.enable = true;

    programs.dconf.enable = true;

    # ibus
    i18n.inputMethod = {
      enable = true;
      type = "ibus";

      ibus.engines = with pkgs.ibus-engines; [
        libpinyin
      ];
    };

    environment.systemPackages = with pkgs; [
      # 终端与字体
      ghostty
      nerd-fonts.jetbrains-mono

      # GNOME 常用工具
      gnome-tweaks
      gnome-extension-manager

      # 剪贴板
      wl-clipboard

      # 托盘与磁盘工具
      networkmanagerapplet
      gnome-disk-utility

      # 归档和缩略图支持
      file-roller
      ffmpegthumbnailer
    ];

    environment.gnome.excludePackages = with pkgs; [
      epiphany # GNOME Web
      geary # 邮件
      gnome-tour # GNOME 导览
      decibels # 音频播放器
      simple-scan # 文档扫描
      gnome-contacts # 联系人
      gnome-weather # 天气
      gnome-maps # 地图
      snapshot # 相机
    ];

    # U 盘、移动硬盘等
    services.udisks2.enable = true;
  };
}
