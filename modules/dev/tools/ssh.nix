{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.dev.tools.ssh;
in

{
  options.modules.dev.tools.ssh = {
    enable = mkEnableOption "SSH";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      home.file.".ssh/id_ed25519" = {
        source = ../../../crypt/ssh/ssh.private.key;
      };

      home.file.".ssh/id_ed25519.pub" = {
        source = ../../../crypt/ssh/ssh.pub.key;
      };
    };
  };
}
