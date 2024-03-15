{ pkgs, ...}: {
  home.packages = with pkgs; [
    kitty
    dolphin
    wofi
  ];

  home.file.".config/hypr/hyprland.conf".source = ./config/hyprland.conf;
}