{
  xdg.configFile."fcitx5/profile".text = ''
    [Groups/0]
    Name=Default
    Default Layout=us
    DefaultIM=pinyin

    [Groups/0/Items/0]
    Name=keyboard-us
    Layout=

    [Groups/0/Items/1]
    Name=pinyin
    Layout=

    [Groups/0/Items/2]
    Name=rime
    Layout=

    [GroupOrder]
    0=Default
  '';

  xdg.configFile."fcitx5/config".text = ''
    [Hotkey]
    EnumerateWithTriggerKeys=True
    EnumerateSkipFirst=False

    [Hotkey/TriggerKeys]
    0=Control+space

    [Hotkey/EnumerateForwardKeys]
    0=Control+Shift+space

    [Hotkey/EnumerateBackwardKeys]

    [Hotkey/ActivateKeys]

    [Hotkey/DeactivateKeys]

    [Hotkey/PrevPage]
    0=Up

    [Hotkey/NextPage]
    0=Down

    [Hotkey/PrevCandidate]
    0=Shift+Tab

    [Hotkey/NextCandidate]
    0=Tab

    [Hotkey/TogglePreedit]
    0=Control+Alt+P

    [Behavior]
    ActiveByDefault=False
    ShareInputState=No
    PreeditEnabledByDefault=True
    ShowInputMethodInformation=True
    showInputMethodInformationWhenFocusIn=False
    CompactInputMethodInformation=True
    ShowFirstInputMethodInformation=True
    DefaultPageSize=5
    OverrideXkbOption=False
    CustomXkbOption=
    EnabledAddons=
    DisabledAddons=
    PreloadInputMethod=True
  '';
}
