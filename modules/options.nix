{ config, lib, pkgs, ... }:

with lib;
with lib.modules;

{
  options = {
    user = {
      name = mkOption {
        type = types.str;
      };
    };
  };

  config = {
    home-manager.users.${config.user.name} = {
      suites.full.enable = true;
    };

    nix.trustedUsers = [ config.user.name ];
  };
}
