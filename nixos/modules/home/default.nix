{ ... }:

{
  home.stateVersion = "26.05";
  imports = [
    # cli
    ./zsh
    ./nvim
    ./git

    # ide 需要包或配置文件
    ./vscode

    # 软件包
    ./packages.nix
  ];
}
