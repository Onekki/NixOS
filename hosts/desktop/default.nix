{ identity, ... }:

{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ../common.nix
    ../../modules/desktop.nix
    ../../modules/desktop-apps.nix
    ../../modules/clash-verge.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  users.users.${identity.username} = {
    initialPassword = "nixos";
    extraGroups = [ "networkmanager" "audio" "video" ];
  };

  system.stateVersion = "26.11";
}
