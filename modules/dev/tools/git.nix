{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.dev.tools.git;
in

{
  options.modules.dev.tools.git = {
    enable = mkEnableOption "Git";
    name = mkOption {
      type = types.str;
      default = "Bobbbay";
    };
    email = mkOption {
      type = types.str;
      default = "abatterysingle@gmail.com";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.git = {
        enable = true;
        aliases.stat = "status";
        userName = cfg.name;
        userEmail = cfg.email;
        signing = {
          signByDefault = true;
          key = null; # Figure it our automatically
        };
        lfs.enable = true;
      };

      home.packages = with pkgs; [ git-crypt gitAndTools.git-absorb ];
    };
  };
}
