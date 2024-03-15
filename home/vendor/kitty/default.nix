{ pkgs, ...}: {
  home.packages = with pkgs; [
    kitty
  ];

  home.file.".config/kitty/kitty.conf".source = ./config/kitty.conf;
}