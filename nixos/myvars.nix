{ pkgs, ... }: {
  networking.hostName = "nixos";

  time.timeZone = "Asia/Shanghai";

  users.users.onekki = {
    isNormalUser = true;
    description = "onekki";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ git ];
  };
}