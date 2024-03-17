{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal
    gnome.nautilus
  ];
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "2";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
      sessionPackages = [
        pkgs.gnome.gnome-session.sessions
      ];
    };
    dpi = 180;
    excludePackages = with pkgs; [
      xterm
    ];
  };
}