{ ... }:

{
  imports = [
    # 基本配置文件
    ./grub
    ./i18n
    ./nixos

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

      gnome.enable = true;
      niri.enable = false;
    };
  };
}
