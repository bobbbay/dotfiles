{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.wezterm;
in
{
  options.programs.wezterm = {
    enable = mkEnableOption "Weztern support";
    target = mkOption {
      type = types.str;
      default = ".config/wezterm";
      description = "The target path, prepended with /home/user, to write the configuration to.";
    };
  };

  config = mkIf cfg.enable {
    home.file."${cfg.target}/wezterm.org" = {
      source = ../config/wezterm.org;
      onChange = ''
        emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "${cfg.target}/wezterm.org")'
      '';
    };

    home.packages = with pkgs; [
      wezterm
    ];
  };
}
