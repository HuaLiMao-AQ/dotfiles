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
}
