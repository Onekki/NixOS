{ pkgs-unstable, pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
  };
}