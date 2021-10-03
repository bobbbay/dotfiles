{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.modules.desktop.apps.fonts;
in

{
  options.modules.desktop.apps.fonts = {
    enable = mkEnableOption "custom fonts";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      home.file."${config.home-manager.users.${config.user.name}.xdg.dataHome}/fonts/pragmata-pro-mono-liga.ttf" = {
        source = ../../../crypt/pragmata-pro-mono-liga.ttf;
      };

      home.packages = with pkgs; [
        (
          nerdfonts.override {
            fonts = [ "Iosevka" ];
          }
        )
      ];

      fonts.fontconfig.enable = true;
    };
  };
}
