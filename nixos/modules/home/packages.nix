{ lib, pkgs, ... }:
with lib;

{
  home.packages = with pkgs; [
    fastfetch
    btop

    # distrobox
    distrobox
    distrobox-tui
  ];
}
