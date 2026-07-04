{ pkgs, ... }:

{
  programs.codexDesktopLinux = {
    enable = true;
    cliPackage = pkgs.codex;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    microsoft-edge
    vscode
  ];
}
