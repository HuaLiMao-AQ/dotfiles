{
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) optionals;

  cfg = osConfig.modules.desktop.enable;

  unstablePkgs = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;

    config = {
      allowUnfree = true;
    };
  };

  homePackages = with pkgs; [
    fastfetch
    btop

    # distrobox
    distrobox
    distrobox-tui
  ];

  desktopPackages = with pkgs; [
    # ide
    vscode
    jetbrains.idea
    android-studio

    # 浏览器
    google-chrome

    # 通讯工具
    unstablePkgs.qq # QQ Linux 官方客户端
    wechat # 微信 Linux 官方客户端
    telegram-desktop # Telegram Desktop
  ];
in
{
  home.packages = homePackages ++ optionals cfg desktopPackages;
}
