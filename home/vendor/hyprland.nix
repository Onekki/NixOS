{ pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    "$super" = "SUPER";

    bind = [
      "$super, T, exec, kitty,"
    ];
  };
}