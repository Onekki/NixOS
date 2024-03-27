{ pkgs, ... }: {
  home.packages = with pkgs; [
    gnome.gnome-themes-extra
  ];

  home.sessionVariables.GTK_THEME = "Catppuccin-Macchiato-Compact-Pink-Dark";

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        size = "compact";
        variant = "macchiato";
      };
    };
    cursorTheme = {
      name = "macOS-BigSur";
      package = pkgs.apple-cursor;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "macOS-BigSur";
    package = pkgs.apple-cursor;
  };
}