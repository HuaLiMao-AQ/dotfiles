{
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption;
in
{
  imports = [
    ./gnome.nix
    ./niri.nix
  ];

  options.modules.desktop.enable = mkEnableOption "desktop configuration";
}
