{ pkgs, ... }:

{
  programs.codexDesktopLinux = {
    enable = true;
    cliPackage = pkgs.codex;
  };

  environment.systemPackages = with pkgs; [
    microsoft-edge
    vscode
  ];
}
