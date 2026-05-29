{ nixos-wsl, ... }:

{
  imports = [
    nixos-wsl.nixosModules.default
    ../common.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  system.stateVersion = "25.11";
}
