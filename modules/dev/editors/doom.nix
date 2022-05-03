{ config, lib, pkgs, ... }:

# Neomacs provides a home-manager module, which needs to be wrapped in order to
# keep the same module style in these dotfiles.

with lib;

let
  cfg = config.modules.dev.editors.doom;
in

{
  options.modules.dev.editors.doom.enable = mkEnableOption "Neomacs";

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.doom-emacs = {
        enable = true;
        doomPrivateDir = pkgs.callPackage ../../../config/doom.d {};
      };

      services.emacs = {
        enable = true;
      };

      home.packages = with pkgs; [
        rust-analyzer
      ];
    };
  };
}
