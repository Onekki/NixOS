{ config, pkgs, ... }: {
  imports = [
    ./vendor/ags
    ./vendor/starship
    ./vendor/kitty
    ./vendor/waybar
    ./vendor/hyprland
    ./vendor/vscode
    ./vendor/msedge
  ];

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  home.username = "onekki";
  home.homeDirectory = "/home/onekki";

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
