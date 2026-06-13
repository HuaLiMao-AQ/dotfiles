{ config, ... }:

{
  imports = [
    # 基本配置文件
    ./grub
    ./common.nix

    # 服务配置文件
    ./docker
    ./tailscale
    ./packages.nix

    # 桌面配置
    ./desktop
  ];

  config.modules = {
    desktop = {
      enable = true;

      niri.enable = true;
    };
  };
}
