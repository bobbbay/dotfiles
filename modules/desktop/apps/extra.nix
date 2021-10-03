{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop.apps.extra;
in

{
  options.modules.desktop.apps.extra = {
    enable = mkEnableOption "extra apps";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.awesome.enable = true;
      programs.wezterm.enable = true;

      xdg.userDirs = {
        enable = true;
        desktop = "$HOME/desktop";
        documents = "$HOME/tmp";
        download = "$HOME/tmp";
        music = "$HOME/tmp";
        pictures = "$HOME/tmp";
        publicShare = "$HOME/tmp";
        templates = "$HOME/tmp";
        videos = "$HOME/tmp";
      };

      services = {
        picom = {
          enable = true;
          shadow = true;
        };

        flameshot.enable = true;
      };
    };
  };
}
