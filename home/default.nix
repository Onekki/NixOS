{ config, pkgs, ... }: {
  imports = [
    ./vendor/ags
    ./vendor/starship
    ./vendor/kitty
    ./vendor/waybar
    ./vendor/hyprland
    ./vendor/vscode
  ];

  home.username = "onekki";
  home.homeDirectory = "/home/onekki";

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
