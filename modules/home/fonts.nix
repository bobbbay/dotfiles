{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts = {
    enable = mkEnableOption "Custom fonts";
  };

  config = mkIf cfg.enable {
    home.file."${config.xdg.dataHome}/fonts/pragmata-pro-mono-liga.ttf" = {
      source = ../../crypt/pragmata-pro-mono-liga.ttf;
    };

    #home.packages = with pkgs; [
    #  (
    #    nerdfonts.override {
    #      fonts = [ "Iosevka" ];
    #    }
    #  )
    #];
  };
}
