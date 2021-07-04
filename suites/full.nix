{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.suites.full;
in
{
  options.suites.full = {
    enable = mkEnableOption "Fully-featured suite";
  };

  config = mkIf cfg.enable {
    profiles.cli.enable = true;
    profiles.dev.enable = true;
    profiles.gui.enable = true;
  };
}
