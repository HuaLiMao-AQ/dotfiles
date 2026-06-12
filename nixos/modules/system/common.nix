{ config, pkgs, ... }:

{
  # nix 设置
  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
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
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # 平台配置
  programs.zsh.enable = true;

  # openssh 配置
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "hualimao" ];
      MaxAuthTries = 3;
    };
  };

  # 动态链接修复
  programs.nix-ld.enable = true;

  system.stateVersion = "26.05";
}
