{
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = osConfig.modules.desktop.niri.enable;
  desktopCfg = osConfig.modules.desktop.enable;
in
{
  config = mkIf (cfg && desktopCfg) {
    xdg.configFile."niri".source = ./../../../../niri;
    xdg.configFile."waybar".source = ./../../../../waybar;
    xdg.configFile."fuzzel".source = ./../../../../fuzzel;
    xdg.configFile."mako".source = ./../../../../mako;
    xdg.configFile."swaylock".source = ./../../../../swaylock;
    xdg.configFile."fcitx5".source = ./../../../../fcitx5;
    xdg.configFile."ghostty".source = ./../../../../ghostty;

  };
}
