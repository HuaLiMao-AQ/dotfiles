/**
  nixos 相关配置
*/
{ lib, ... }:
let
  inherit (lib) mkForce;
in
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
      substituters = mkForce [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
        "https://cache.nixos.org?priority=40"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # 动态链接修复
  programs.nix-ld.enable = true;
}
