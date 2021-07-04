{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  home-manager.users.bobbbay = {
    suites.full.enable = true;
  };

  cachix.enable = true;

  boot.extraModprobeConfig = ''
    options snd-hda-intel model=pch position_fix=1
    options snd_intel_dspcfg dsp_driver=1
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [ alsa-firmware ];

  networking = {
    hostName = "NotYourLaptop";
    useDHCP = false;
    interfaces.wlo1.useDHCP = true;

    wireless = {
      enable = true;
      interfaces = [ "wlo1" ];

      networks = {
        "Hay-Fi" = {
          pskRaw = "7ef3ca268a6ba07533537dafae0e70504bc67dd805aa8ef9686f47b6f2e8457a";
        };
      };
    };
  };

  time.timeZone = "Canada/Eastern";

  services = {
    xserver = {
      enable = true;
      windowManager.awesome.enable = true;
      layout = "us";
      libinput.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users = {
    bobbbay = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" ];
    };
  };

  system.stateVersion = "21.05"; # Before you ask: yes, I read the comment.
}
