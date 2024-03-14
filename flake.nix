{
  description = "A very basic flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager = {
              extraSpecialArgs = { inherit inputs; };
              users = {
                onekki = import ./home/configuration.nix;
              };
            };
          }
        ];
      };
    };
  };
}
