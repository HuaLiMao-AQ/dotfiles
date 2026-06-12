# modules/zsh/default.nix
{ pkgs, lib, config, ... }:
with lib;

let
  cfg = config.modules.zsh;
in
{
  options.modules.zsh.enable = mkEnableOption "zsh";

  config = mkIf cfg.enable {

      home.packages = with pkgs; [
            zsh
            git
            curl

            fzf
            eza

            bat
            ripgrep
            fd
      ];
  };
}
