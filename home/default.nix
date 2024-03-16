{ config, pkgs, ... }: {
  imports = [
    ./vendor/ags
    ./vendor/starship
    ./vendor/kitty
    ./vendor/waybar
    ./vendor/hyprland
  ];

  home.username = "onekki";
  home.homeDirectory = "/home/onekki";

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
