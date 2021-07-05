{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.profiles.gui;
in
{
  options.profiles.gui.enable = mkEnableOption "GUI programs";

  config = mkIf cfg.enable {
    modules.fonts.enable = true;
    programs.awesome.enable = true;
  };
}
