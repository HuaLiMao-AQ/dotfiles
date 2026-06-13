{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.desktop;
in
{
  config = mkIf cfg.enable {
    # 非自由软件
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      # ide
      vscode
    ];
  };
}
