{ config, pkgs, ... }: {
  imports = [
    ./vendor/hyprland.nix
  ];

  home.username = "onekki";
  home.homeDirectory = "/home/onekki";

  home.packages = with pkgs;[
    neofetch
    which

    kitty
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
