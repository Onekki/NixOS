{ pkgs, ...}: {
  programs.bash.enable = true;
  programs.starship = {
    enable = true;
  };

  home.file.".config/starship.toml".source = ./config/starship.toml;
}