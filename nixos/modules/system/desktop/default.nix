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
    embeddedTheme = "japanese_aesthetic";
  };
in
{
  imports = [
    ./packages.nix
    ./niri.nix
  ];

  options.modules.desktop.enable = mkEnableOption "desktop configuration";

  config = mkIf cfg.enable {
    environment.systemPackages = [
      sddmTheme
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
  };
}
