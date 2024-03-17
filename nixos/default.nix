{ pkgs, ... }: {
  imports = [
    ./bootloader.nix
    ./hardware.nix
    ./i18n.nix
    ./myvars.nix
    ./networking.nix
    ./xserver.nix

    ./vendor/hyprland.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [ git neofetch ];

  services.openssh.enable = true;
  networking.firewall.enable = false;

  system.stateVersion = "23.11";
}
