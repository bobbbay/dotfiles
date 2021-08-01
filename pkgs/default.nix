final: prev:

{
  dude = prev.pkgs.writeScriptBin "dude" ''
    #!${prev.pkgs.stdenv.shell}

    case $1 in
      switch|s) sudo nixos-rebuild switch;;
      fmt|f) fd .nix | xargs nixpkgs-fmt;;
      update|up) nix flake update;;
      upgrade|ug) nix flake update && sudo nixos-rebuild switch;;
      unlock|u) git crypt unlock $2;;
      "") echo "Options:
          switch | s: run nixos-rebuild switch
          fmt | f: run nixpkgs-fmt on all Nix files in this directory
          update | up: run nix flake update
          upgrade | ug: run nix flake update, then rebuild
          unlock | u </path/to/symmetrical/key>: unlock the git crypt using the provided symmetrical key";;
      *) echo "Error: unknown command $1" && exit 1;;
    esac
  '';
  guacamole = prev.callPackage ./guacamole { };
}
