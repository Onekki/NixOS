{ pkgs, nixos-cli, ... }:

{
  environment.systemPackages = [
    nixos-cli.packages.${pkgs.stdenv.hostPlatform.system}.nixos-cli
  ];
}
