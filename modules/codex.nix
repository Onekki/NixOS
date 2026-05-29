{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs_22
    cacert
  ];

  environment.shellInit = ''
    export NPM_CONFIG_PREFIX="$HOME/.local"
    case ":$PATH:" in
      *":$HOME/.local/bin:"*) ;;
      *) export PATH="$HOME/.local/bin:$PATH" ;;
    esac
  '';
}
