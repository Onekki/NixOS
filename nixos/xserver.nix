{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
      sessionPackages = [
        pkgs.gnome.gnome-session.sessions
      ];
    };
  };
}