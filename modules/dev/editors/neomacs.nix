{ config, lib, pkgs, ... }:

# Neomacs provides a home-manager module, which needs to be wrapped in order to
# keep the same module style in these dotfiles.

with lib;

let
  cfg = config.modules.dev.editors.neomacs;
in

{
  options.modules.dev.editors.neomacs.enable = mkEnableOption "Neomacs";

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      modules.neomacs.enable = true;
    };
  };
}
