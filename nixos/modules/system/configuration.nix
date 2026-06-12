{ config, pkgs, ... }:

{
  # nix 设置
  nix = {
    settings = {
        auto-optimise-store = true;
        allowed-users = [ "@wheel" ];
        experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
    };
  };

  # boot
  boot = {
      loader = {
        grub = {
         enable = true;
         efiSupport = true;
         device = "nodev";
        };
        efi = {
            efiSysMountPoint = "/boot/efi";
            canTouchEfiVariables = true;
        };
      };
  };

  # 本地化
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # 用户配置
  users.users.hualimao = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # 平台配置
  programs.zsh.enable = true;

  services.openssh.enable = true;
  
  system.stateVersion = "26.05";
}
