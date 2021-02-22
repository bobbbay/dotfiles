{ pkgs, ... }:

{
  xsession = {
    enable = true;

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
        hp.xmonad-contrib
      ];
      config = ../../other/bobbbay/xmonad.hs;
    };
  };
  xsession.scriptPath = ".hm-xsession";

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    # theme = ../../other/rofi;
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
      size = "16x16";
    };
    settings = {
      global = {
        monitor = 0;
        geometry = "600x50-50+65";
        shrink = "yes";
        transparency = 10;
        padding = 16;
        horizontal_padding = 16;
        font = "JetBrainsMono Nerd Font 10";
        line_height = 4;
        format = ''<b>%s</b>\n%b'';
      };
    };
  };

  services.screen-locker = {
    enable = true;
    inactiveInterval = 1;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
    xautolockExtraOptions = [
      "Xautolock.killer: systemctl suspend"
    ];
  };

  home.packages = [
    pkgs.dmenu
  ];
}
