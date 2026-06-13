/**
  vscode ssh remote 需要动态链接支持
  如果出现ld问题，检查如下配置是否开启：
    programs.nix-ld.enable
*/
{
  lib,
  pkgs,
  config,
  ...
}:
with lib;

{
  options.modules.vscode.enable = mkEnableOption "vscode";

  config = mkIf config.modules.vscode.enable {
    home.packages = with pkgs; [
      # nix
      nixd
      nixfmt
    ];
  };
}
