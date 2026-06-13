{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.desktop;

  sddmThemeName = "sddm-astronaut-theme";

  sddmTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
  };
in
{
  imports = [
    ./niri.nix
  ];

  options.modules.desktop.enable = mkEnableOption "desktop configuration";

  config = mkIf cfg.enable {
    environment.systemPackages = [
      sddmTheme
      pkgs.fcitx5-mellow-themes
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      theme = sddmThemeName;

      extraPackages = [
        sddmTheme
      ];

      # sddm 启用中午
      settings.General.GreeterEnvironment = "LANG=zh_CN.UTF-8,LANGUAGE=zh_CN:zh";
    };

    security.polkit.enable = true;

    # fcitx5
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        waylandFrontend = true;

        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-rime
          qt6Packages.fcitx5-configtool
          qt6Packages.fcitx5-chinese-addons
        ];
      };
    };
  };
}
