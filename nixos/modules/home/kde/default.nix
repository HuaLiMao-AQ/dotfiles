{
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = osConfig.modules.desktop.kde.enable;
  desktopCfg = osConfig.modules.desktop.enable;
in
{
  config = mkIf (cfg && desktopCfg) {
    xdg.configFile."fcitx5".source = ./../../../../fcitx5;
    xdg.configFile."ghostty".source = ./../../../../ghostty;

    home.packages = with pkgs; [
      catppuccin-kde
      papirus-icon-theme
      bibata-cursors
      tela-icon-theme
    ];
  };
}
