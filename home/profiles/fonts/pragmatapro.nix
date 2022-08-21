{
  config,
  pkgs,
  ...
}: let
  drv = pkgs.stdenv.mkDerivation {
    pname = "pragmatapro";
    version = "0.829";
    src = ../../../secrets/fonts/pragmata-pro-mono-liga.age;

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/.local/share/fonts
      cp $src $out/.local/share/fonts
    '';
  };
in {
  home.packages = [
     drv
  ];
}
