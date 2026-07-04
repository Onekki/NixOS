{ identity, ... }:

{
  sops.defaultSopsFile = ../secrets/cc-switch.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  sops.secrets."cc-switch/provider-env" = {
    owner = identity.username;
    group = "users";
    mode = "0400";
    path = "${identity.homeDirectory}/.config/cc-switch/provider-env";
  };
}
