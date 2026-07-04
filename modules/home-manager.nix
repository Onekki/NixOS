{ dms, identity, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-bak";
  home-manager.sharedModules = [
    dms.homeModules.dank-material-shell
  ];
  home-manager.extraSpecialArgs = {
    inherit identity;
  };
  home-manager.users.${identity.username} = import ../home/nixos;
}
