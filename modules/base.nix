{ identity, pkgs, ... }:

{
  time.timeZone = "Asia/Shanghai";

  users.users.${identity.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.bashInteractive;
  };
}
