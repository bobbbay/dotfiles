{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.wm;
in
{
  options.modules.wm = {
    enable = mkEnableOption "Customization of the Window Manager";
  };

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      userDirs = {
        desktop = "\$HOME/desktop";
        documents = "\$HOME/documents";
        download = "\$HOME/downloads";
        music = "\$HOME/music";
        pictures = "\$HOME/pictures";
        publicShare = "\$HOME/public";
        templates = "\$HOME/templates";
        videos = "\$HOME/videos";
      };
    };

    # TODO: Use xdg.configFile
    home.file.".config/awesome" = {
      source = ../../config/awesome;
      recursive = true;
    };

    home.file.".config/awesome/modules/awesome-wm-widgets" = {
      source = pkgs.fetchFromGitHub {
        owner = "streetturtle";
        repo = "awesome-wm-widgets";
        rev = "a808ead3c74d57a7ccdb7f9e55cfa10a136d488c";
        sha256 = "mSSFQBcpPsLgtEji+a+J4lVMIf2vFjIhUIrawwN5KNw=";
      };
      recursive = true;
    };

    home.file.".config/awesome/modules/bling" = {
      source = pkgs.fetchFromGitHub {
        owner = "blingcorp";
        repo = "bling";
        rev = "75ff07a47ee93279bfba5f567637470a0f50774f";
        sha256 = "VWb21Ony0UO0N6Cfi1UEfdcAS6O5zCQJtesR8Vh2CNY=";
      };
      recursive = true;
      onChange = "awesome -k";
    };

    home.packages = with pkgs; [
      acpi # For battery widget
      light # For brightness customization
    ];
  };
}
