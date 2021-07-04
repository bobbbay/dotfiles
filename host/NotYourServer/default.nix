{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  home-manager.users.main.config.profiles.cli.enable = true;

  boot.cleanTmpDir = true;
  # networking.hostName = "hosting";
  networking.firewall.allowPing = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeUJ4JvoGogNOkmJ+dU83xNK28ccUZOrDe4PgQ71GOS abatterysingle@gmail.com"
  ];

  users.users.main = {
    isNormalUser = true;
    home = "/home/main";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeUJ4JvoGogNOkmJ+dU83xNK28ccUZOrDe4PgQ71GOS abatterysingle@gmail.com"
    ];
  };

  systemd.services.bobsite = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Start the Bobsite webserver.";

    serviceConfig = {
      Type = "forking";
      User = "main";
      ExecStart = ''nix run github:bobbbay/site -- run'';
    };
  };
}
