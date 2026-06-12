{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "26.05";
    imports = [
        # cli
        ./zsh
        ./nvim
    ];
}
