{ pkgs, cc-switch-cli, ... }:

{
  environment.systemPackages = [
    cc-switch-cli.packages.${pkgs.stdenv.hostPlatform.system}.cc-switch
  ];

  environment.shellInit = ''
    export CC_SWITCH_CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/cc-switch"
  '';
}
