{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [ ../../modules/home/default.nix ];
  config.modules = {
    # cli
    nvim.enable = true;
    zsh.enable = true;
  };
}
