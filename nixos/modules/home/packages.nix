{ lib, pkgs, ... }:
with lib;

{
  home.packages = with pkgs; [
    fastfetch
    btop

    # fmt 工具
    nixfmt
    
    # distrobox
    distrobox
    distrobox-tui
  ];
}
