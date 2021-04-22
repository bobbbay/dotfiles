{ config, lib, pkgs, ... }:

with builtins;
with lib;

let cfg = config.profiles.misc;
in {
  options.profiles.misc = { enable = mkEnableOption "Misc packages"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
