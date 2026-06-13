{ pkgs, ... }:

let
  grubTheme = pkgs.catppuccin-grub.override {
    flavor = "mocha";
  };
in
{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";

      theme = grubTheme;

      # 保留的旧系统配置数量
      configurationLimit = 30;

      # 双系统
      useOSProber = true;
    };

    efi = {
      efiSysMountPoint = "/boot/efi";
      canTouchEfiVariables = true;
    };
  };
}
