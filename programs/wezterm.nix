{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.wezterm;
in
{
  options.programs.wezterm = {
    enable = mkEnableOption "Weztern support";
  };

  config = mkIf cfg.enable {
    home.file.".config/wezterm/wezterm.lua" = {
      source = ../config/weterm.lua;
    };

    home.programs = with pkgs; [
      wezterm
    ];
  };
}
