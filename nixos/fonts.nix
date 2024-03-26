{ pkgs, ... }: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      sarasa-gothic
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Sarasa Fixed Slab SC" ];
        sansSerif = [ "Sarasa Fixed SC" ];
        monospace = [ "Sarasa Mono SC" ];
      };
    };
  };
}