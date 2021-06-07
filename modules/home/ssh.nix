{ lib, pkgs, config, ... }:

with lib;

let cfg = config.modules.ssh;
in
{
  options.modules.ssh.enable = mkEnableOption "SSH configuration";

  config = mkIf cfg.enable {
    home.file.".ssh/id_ed25519" = {
      source = ../../crypt/ssh/ssh.private.key;
    };

    home.file.".ssh/id_ed25519.pub" = {
      source = ../../crypt/ssh/ssh.pub.key;
    };
  };
}
