{ pkgs, ... }:

{
  programs.clash-verge = {
    enable = true;
    package = pkgs.clash-verge-rev;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
  };
}
