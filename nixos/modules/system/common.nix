{ pkgs, ... }:

{
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
}
