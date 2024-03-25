{ pkgs, ... }: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "NerdFontsSymbolsOnly" ];
    })
    dconf
    gtk-engine-murrine
    gnome.gnome-themes-extra
  ];

  home.sessionVariables.GTK_THEME = "Catppuccin-Macchiato-Compact-Mauve-Dark";

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Compact-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        size = "compact";
        tweaks = [];
        variant = "macchiato";
      };
    };
    cursorTheme = {
      name = "Catppuccin-Macchiato-Mauve-Cursors";
      package = pkgs.catppuccin-cursors.macchiatoMauve;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.catppuccin-cursors.macchiatoMauve;
    name = "Catppuccin-Macchiato-Mauve-Cursors";
  };
}