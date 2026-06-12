{
  description = "NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;

      # host 与 hostname 分开配置，避免同一 hostname 配置到同一局域网多台设备
      mkSystem =
        pkgs: system: host: hostname:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            { networking.hostName = hostname; }

            # 系统配置文件
            ./modules/system/default.nix

            # 硬件配置文件
            (./. + "/hosts/${host}/hardware-configuration.nix")

            # home-manager
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                backupFileExtension = "hm-backup";
                extraSpecialArgs = { inherit inputs; };
                users.hualimao = (./. + "/hosts/${host}/user.nix");
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      nixosConfigurations = {
        catserver = mkSystem inputs.nixpkgs system "minipc" "catserver";
      };
    };
}
