{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.emacs;
in
{
  options.modules.emacs = {
    enable = mkEnableOption "Emacs modules";
    src = mkOption {
      type = types.path;
      default = ../config/emacs;
    };
    target = mkOption {
      type = types.str;
      default = ".emacs.d";
    };
  };

  config = mkIf cfg.enable {
    #home.file = {
    #  "${cfg.target}" = {
    #    source = cfg.src;
    #    recursive = true;
    #  };
    #};
  };
}