{ identity, nixos-wsl, ... }:

{
  imports = [
    nixos-wsl.nixosModules.default
    ../common.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = identity.username;

  system.stateVersion = "26.11";
}
