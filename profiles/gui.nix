{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.profiles.gui;
  # TODO: Get rid of this
  sp = pkgs.writeScriptBin "sp" (builtins.readFile ./sp);
in
{
  options.profiles.gui.enable = mkEnableOption "GUI programs";

  config = mkIf cfg.enable {
    modules.fonts.enable = true;
    programs.awesome.enable = true;
    programs.nyxt.enable = true;
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

    home.packages = with pkgs; [
      spotify
      sp
      zoom-us
    ];
  };
}
