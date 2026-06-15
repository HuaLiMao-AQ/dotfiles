{
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = osConfig.modules.desktop.gnome.enable;
  desktopCfg = osConfig.modules.desktop.enable;
in
{
  config = mkIf (cfg && desktopCfg) {
    xdg.configFile."ghostty".source = ./../../../../ghostty;
  };
}
