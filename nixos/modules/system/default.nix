{ config, ... }:

{
  imports = [
    ./common.nix
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
