{ dms, identity, pkgs, ... }:

{
  hardware.graphics.enable = true;

  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  security.polkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.niri.enable = true;

  services.displayManager.dms-greeter = {
    enable = true;
    package = dms.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell;
    compositor = {
      name = "niri";
    };
    configHome = identity.homeDirectory;
    logs.save = true;
  };

  services.displayManager.defaultSession = "niri";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = [
        pkgs.fcitx5-gtk
        pkgs.fcitx5-rime
        pkgs.qt6Packages.fcitx5-chinese-addons
      ];
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    source-han-sans
    source-han-serif
  ];

  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    INPUT_METHOD = "fcitx";
    NIXOS_OZONE_WL = "1";
    QT_IM_MODULE = "fcitx";
    QT_QPA_PLATFORM = "wayland;xcb";
    XMODIFIERS = "@im=fcitx";
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    grim
    slurp
    wl-clipboard
    wlr-randr
  ];
}
