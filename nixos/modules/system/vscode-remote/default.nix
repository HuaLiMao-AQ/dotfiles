{ pkgs, ... }:

{
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    bash
    curl
    wget
    git
    gnutar
    gzip
    nodejs
  ];
}
