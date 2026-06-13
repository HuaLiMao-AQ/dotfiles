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
    };

    security.polkit.enable = true;
  };
}
