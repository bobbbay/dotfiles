{ config, pkgs, lib, home, ... }:
with lib;
let
  cfg = config.modules.emacs.utils;
in
{
  options.modules.emacs.utils = {
    enable = mkEnableOption "General utilities for Emacs";
  };

  config = mkIf cfg.enable {
    # TODO
  };
}
