{ pkgs, ...}: {
  home.packages = with pkgs; [
    dolphin
    wofi
  ];

  home.file.".config/hypr/hyprland.conf".source = ./config/hyprland.conf;
}