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
        "Hay-Fi-5G" = {
          pskRaw = "10d016e2600e755883a5f1cdb1616024d78d23025a05e6290c4fb71570d3f21e";
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
      xkbOptions = "compose:ralt";
      libinput.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };

    # kmonad = {
    #   enable = true;
    #   configfiles = [ ../../config/kmonad.kbd ];
    # };

#     guacamole = {
#       enable = true;
#       user = "bobbbay";
#     };
# 
    offlineimap.enable = true;

    postgresql.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users = {
    bobbbay = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "input" "uinput" ];
    };
  };

  system.stateVersion = "21.05"; # Before you ask: yes, I read the comment.
}
