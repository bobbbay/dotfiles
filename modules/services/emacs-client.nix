{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.emacs-client;
in
{
  options.services.emacs-client = {
    enable = mkEnableOption "Enable Emacs Service";

    package = mkOption {
      type = types.package;
      default = pkgs.emacs;
      defaultText = "pkgs.emacs";
      description = ''
        Emacs derivation to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.emacs-client = {
      serviceConfig = {
        Type = "forking";
        ExecStart = "exec ${cfg.package}/bin/emacs --daemon'";
        ExecStop = "${cfg.package}/bin/emacsclient --eval (kill-emacs)";
        Restart = "always";
      };
    };
  };
}
