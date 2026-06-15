{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkForce;
in
{
  imports = [
    ./kde.nix
  ];

  options.modules.desktop.enable = mkEnableOption "desktop configuration";

  config = mkIf config.modules.desktop.enable {

    # 桌面环境默认中文
    # 强制覆盖掉
    i18n.defaultLocale = mkForce "zh_CN.UTF-8";
  };
}
