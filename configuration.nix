{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  networking.hostName = "NotYourPC";
  networking.wireless.enable = true;

  time.timeZone = "Canada/Eastern";

  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  security.doas = {
    enable = true;
    extraRules = [
      { groups = ["wheel"]; noPass = true; keepEnv = true; }
    ];
  };

  # TODO: This should be inside an hm config
  services.xserver.enable = true;
  services.xserver = {
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
  };
  services.xserver.displayManager.defaultSession = "none+xmonad";

  # TODO: Maybe, this should be inside an hm config
  fonts.fonts = with pkgs; [
    iosevka nerdfonts
  ];

  environment.systemPackages = with pkgs; [
    git
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.bobbbay = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "";
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 8080 ];
  networking.firewall.allowedUDPPorts = [ 8080 ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home-manager.users.bobbbay = { ... }: {
    imports = [ ./home-manager/bobbbay ];
  };

  # Darling erasure
  environment.etc = {
    nixos.source = "/persist/etc/nixos";
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
    adjtime.source = "/persist/etc/adjtime";
    NIXOS.source = "/persist/etc/NIXOS";
    machine-id.source = "/persist/etc/machine-id";
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    "L /etc/wpa_supplicant.conf - - - - /persist/etc/wpa_supplicant.conf"
  ];

  security.sudo = {
    extraConfig = ''
      # Rollback results in sudo lectures after each reboot
      Defaults lecture = never
    '';
    wheelNeedsPassword = false;
  };

  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -p /mnt
    mount -o subvol=/ /dev/mapper/luks /mnt

    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "[DARLING] Deleting /$subvolume subvolume..."
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "[DARLING] Deleting /root subvolume..."
    btrfs subvolume delete /mnt/root

    echo "[DARLING] Restoring blank /root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root

    umount /mnt
  '';

  system.stateVersion = "unstable";
}
