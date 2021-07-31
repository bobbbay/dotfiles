{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.programs.nyxt;
in
{
  options.programs.nyxt = {
    enable = mkEnableOption "Nyxt browser configurations";
    target = mkOption {
      type = types.str;
      default = ".config/nyxt";
      description = "The target configuration directory.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ nyxt ];

    home.file."${cfg.target}/init.org" = {
      source = ../config/nyxt.org;
      onChange = ''
        emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "${cfg.target}/init.org")'
      '';
    };
  };
}
