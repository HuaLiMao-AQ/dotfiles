{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # cli
        nvim.enable = true;
        zsh.enable = true;
    };
}
