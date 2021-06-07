{ lib, pkgs, config, modulesPath, ... }:

with lib;
{
  imports = [ ./hardware-configuration.nix ];

  home-manager.users.bobbbay = {
    imports = [ ../../modules/home ];
    config.modules.dev.enable = true;
    config.modules.cli.enable = true;
    config.modules.emacs.enable = true;
    config.modules.ssh.enable = true;
  };

  programs.gnupg.agent.enable = true;
}
