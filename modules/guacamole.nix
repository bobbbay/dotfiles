{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.guacamole;
  uid = 54201;
  gid = 54201;

  guacamole_version = "0.9.9";
  guacamole-client = pkgs.fetchurl {
    url = "mirror://sourceforge/guacamole/guacamole-${guacamole_version}.war";
    sha256 = "195zriwf3gpgk1nfcivs2ws4w48ljh1kbdmlbk0v7jwiigis472y";
  };
  guacamole_path_suffix = removeSuffix ".war" (removePrefix "/nix/store/" guacamole-client);
in

{
  options = {
    services.guacamole = {
      enable = mkOption {
        description = "Enable guacamole";
        default = false;
        type = types.bool;
      };
      user = mkOption {
        description = "User account under which guacd runs.";
        default = "guacamole";
        type = types.str;
      };
      group = mkOption {
        description = "Group account under which guacd runs.";
        default = "guacamole";
        type = types.str;
      };
      guacamole_path = mkOption {
        default = guacamole_path_suffix;
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.packageOverrides = pkgs: with pkgs; rec {
      #guacamole-client = callPackage ./guacamole-client {};
      guacamole-server = callPackage ./guacamole-server { pango = gnome2.pango; };
    };

    systemd.services.guacd = {
      description = "Guacamole Proxy Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        #Type = "forking";
        Type = "simple";
        PermissionsStartOnly = true;
        ExecStartPre = pkgs.writeScript "guacd-prestart.sh" ''
          #!/bin/sh
          mkdir -p /srv/guacamole
          chown ${config.services.tomcat.user}.${config.services.tomcat.group} /srv/guacamole
        '';
        ExecStart = "${pkgs.guacamole-server}/bin/guacd -f -L debug";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
      };
    };

    services.tomcat = {
      enable = true;
      webapps = [ guacamole-client ];
    };
    systemd.services.tomcat.serviceConfig.Environment = ''"GUACAMOLE_HOME=/srv/guacamole"'';

    users.users = optionalAttrs (cfg.user == "guacamole") (singleton {
      name = cfg.user;
      group = cfg.group;
      uid = uid;
    });

#     users.groups = optionalAttrs (cfg.group == "guacamole") (singleton {
#       name = cfg.group;
#       gid = gid;
#     });
  };
}
