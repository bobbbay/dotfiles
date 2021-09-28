{ config, pkgs, lib, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/virtualbox-demo.nix> ];

  home-manager.users.demo = {
    suites.full.enable = true;
  };

  nix.trustedUsers = [ "demo" ];

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
