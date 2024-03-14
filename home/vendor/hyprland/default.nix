{ pkgs, ...}: {

  home.packages = with pkgs; [
    kitty
    dolphin
    wofi
    waybar
  ];

  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
}