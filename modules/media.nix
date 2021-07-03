{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.media;
in

{
  options.media = {
    enable = mkEnableOption "Media server configurations";
  };

  config = mkIf cfg.enable {
    services = {
      plex = {
        enable = true;
        openFirewall = true;
      };

      jackett = {
        enable = true;
        openFirewall = true;
      };

      radarr = {
        enable = true;
        openFirewall = true;
      };

      sonarr = {
        enable = true;
        openFirewall = true;
      };
    };

    environment.systemPackages = with pkgs; [
      aria
      qbittorrent
    ];
  };
}
