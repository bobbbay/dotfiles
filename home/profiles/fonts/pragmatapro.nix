{
  config,
  pkgs,
  ...
}: let
  drv = pkgs.stdenv.mkDerivation {
    pname = "pragmatapro";
    version = "0.829";

    installPhase = ''
      font=${../../../secrets/fonts/pragmata-pro-mono-liga.age}
      cp $font ~/.local/share/fonts
      fc-cache
    '';
  };
in {
  home.packages = [
     drv
  ];
}
