{ config, pkgs, ... }:

{
    home.username = "onekki";
    home.homeDirectory = "/home/onekki";

    home.packages = with pkgs;[
      neofetch

      which
      tree
    ];

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
}
