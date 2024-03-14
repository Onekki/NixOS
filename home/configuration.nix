{ config, pkgs, ... }:

{
    home.username = "onekki";
    home.homeDirectory = "/home/onekki";

    # 4K monitor: mouse & font size
    xresources.properties = {
      "Xcursor.size" = 16;
      "Xft.dpi" = 172;
    };

    home.packages = with pkgs;[
      neofetch

      which
      tree
    ];

    programs.home-manager.enable = true;
    programs.git.enable = true;

    systemd.user.startServices = "sd-switch";

    home.stateVersion = "23.11";
}
