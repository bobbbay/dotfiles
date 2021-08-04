{ config, pkgs, lib, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/virtualbox-demo.nix> ];

  home-manager.users.demo = {
    suites.full.enable = true;
  };

  # Let demo build as a trusted user.
  nix.trustedUsers = [ "demo" ];

# Mount a VirtualBox shared folder.
# This is configurable in the VirtualBox menu at
# Machine / Settings / Shared Folders.
# fileSystems."/mnt" = {
#   fsType = "vboxsf";
#   device = "nameofdevicetomount";
#   options = [ "rw" ];
# };

# By default, the NixOS VirtualBox demo image includes SDDM and Plasma.
# If you prefer another desktop manager or display manager, you may want
# to disable the default.
#  services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
#  services.xserver.displayManager.sddm.enable = lib.mkForce false;
  
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

# Enable GDM/GNOME by uncommenting above two lines and two lines below.
# services.xserver.displayManager.gdm.enable = true;
# services.xserver.desktopManager.gnome.enable = true;

# Set your time zone.
# time.timeZone = "Europe/Amsterdam";

# List packages installed in system profile. To search, run:
# \$ nix search wget
# environment.systemPackages = with pkgs; [
#   wget vim
# ];

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

}
