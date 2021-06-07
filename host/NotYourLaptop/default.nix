{ lib, pkgs, config, modulesPath, ... }:

with lib;
{
  imports = [ ./hardware-configuration.nix ];

  home-manager.users.bobbbay = {
    imports = [ ../../profiles/dev ../../profiles/cli ../../modules/home ];
    config.profiles.dev.enable = true;
    config.profiles.cli.enable = true;
    config.modules.emacs.enable = true;
    config.modules.ssh.enable = true;
  };

  programs.gnupg.agent.enable = true;
}
