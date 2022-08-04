{ config, lib, pkgs, ... }:

let
  cfg = config.system.secrets;
in {
  options.system.secrets = {
    enable = lib.mkOption {
      type = with lib.types; bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets = { };
  };
}
