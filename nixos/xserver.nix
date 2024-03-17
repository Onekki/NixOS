{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = with pkgs; [
      xterm
    ];
  };

  environment.gnome.excludePackages = (with pkgs; [
    gedit
    gnome-tour
    gnome-photos
  ]) ++ (with pkgs.gnome; [
    tali
    geary
    totem
    iagno
    hitori
    evince
    cheese
    atomix
    epiphany
    gnome-maps
    gnome-music
    gnome-contacts
    gnome-terminal
    gnome-characters
  ]);
}