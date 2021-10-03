{ config, pkgs, lib, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/virtualbox-demo.nix> ];

  user = {
    name = "demo";
  };

  modules = {
    cachix.enable = true;

    dev = {
      editors = {
        neomacs.enable = true;
        # TODO neovitality.enable = true;
      };

      tools = {
        git.enable = true;
        direnv.enable = true;
        gpg.enable = true;
        ssh.enable = true;
      };

      # TODO Separate these into their own modules.
      extra.enable = true;
    };

    desktop = {
      term = {
        bash.enable = true;
        extra.enable = true;
      };

      apps = {
        extra.enable = true;
        fonts.enable = true;
      };
    };
  };

  services = {
    xserver = {
      enable = true;
      windowManager.awesome.enable = true;
      layout = "us";
      xkbOptions = "compose:ralt";
      libinput.enable = true;

      desktopManager.plasma5.enable = lib.mkForce false;
      displayManager.sddm.enable = lib.mkForce false;
    };
  };
}
