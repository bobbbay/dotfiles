{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  home-manager.users.bobbbay = {
    imports = [ ../../modules/home ];
    config.modules.dev.enable = true;
    config.modules.cli.enable = true;
    config.modules.emacs.enable = true;
    config.modules.ssh.enable = true;
    config.modules.wm.enable = true;
    config.modules.fonts.enable = true;
  };

  boot.extraModprobeConfig = ''
    options snd-hda-intel dmic_detect=0
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
