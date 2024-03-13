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

    programs.git = {
      enable = true;
      userName = "Onekki";
      userEmail = "zhuwq@outlook.com";
    };

    home.stateVersion = "23.11";

    programs.home-manager.enable = true;
}
