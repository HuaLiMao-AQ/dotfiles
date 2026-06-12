{ ... }:

{
  home.stateVersion = "26.05";
  imports = [
    # cli
    ./zsh
    ./nvim
    ./git

    # 软件包
    ./packages.nix
  ];
}
