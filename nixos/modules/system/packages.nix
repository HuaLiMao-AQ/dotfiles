# modules/system/base.nix
{ pkgs, inputs, ... }:

{
  imports = [
    # nix-index-database
    inputs.nix-index-database.nixosModules.nix-index
  ];

  # 启用 comma
  programs.nix-index-database.comma.enable = true;

  # 系统软件
  environment.systemPackages = with pkgs; [
    # essential
    vim
    nano
    git
    curl
    wget
    openssh
    bash

    # archives
    unzip
    zip
    gnutar
    gzip
    xz
    p7zip

    # inspection
    file
    tree
    which
    lsof
    pciutils
    usbutils
    dmidecode
    jq

    # disk / filesystem
    parted
    gptfdisk
    dosfstools
    e2fsprogs
    ntfs3g
    exfatprogs

    # monitor
    htop
    btop
    iotop
    sysstat

    # build basics
    gcc
    gnumake
    pkg-config

    # nix tools
    nh
    nix-output-monitor
    nvd
    nix-tree
    nix-du
  ];
}
