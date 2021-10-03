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
    nix.trustedUsers = [ config.user.name ];
  };
}
