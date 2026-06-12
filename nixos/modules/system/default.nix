{ ... }:

{
  imports = [
    ./common.nix
    ./docker
    ./tailscale

    ./packages.nix
  ];
}
