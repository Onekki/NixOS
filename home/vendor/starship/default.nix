{ pkgs, ...}: {
  programs.starship = {
    enable = true;
  };

  home.file.".config/starship.toml".source = ./config/starship.toml;
}