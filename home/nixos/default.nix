{ identity, ... }:

{
  imports = [
    ./cc-switch.nix
    ./dms.nix
    ./fcitx5.nix
    ./git.nix
  ];

  home.username = identity.username;
  home.homeDirectory = identity.homeDirectory;
  home.stateVersion = "26.11";

  xdg.enable = true;
}
