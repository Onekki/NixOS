{ pkgs, ... }:

{
  # Required by VS Code Remote-WSL because the downloaded server binary
  # expects a normal Linux dynamic loader path.
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    wget
  ];
}
