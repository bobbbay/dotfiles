{ config, pkgs, lib, inputs, ... }:
let
  cfg = config.profiles.emacs;
in
{

  options.profiles.emacs.enable =
    lib.mkOption {
      description = "Enable custom emacs configuration.";
      type = with lib.types; bool;
      default = true;
    };

  config = lib.mkIf config.profiles.emacs.enable {
    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ../../../other/bobbbay/doom;
    };

    services.emacs = {
      enable = true;
    };
  };
}
