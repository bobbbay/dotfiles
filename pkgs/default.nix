final: prev:

{
  dude = prev.pkgs.writeScriptBin "dude" ''
    #!${prev.pkgs.stdenv.shell}

    case $1 in
      switch|s) sudo nixos-rebuild switch;;
      fmt|f) fd .nix | xargs nixpkgs-fmt;;
      unlock|u) git crypt unlock $2;;
      "") echo "Options:
          switch | s: run nixos-rebuild switch
          fmt | f: run nixpkgs-fmt on all Nix files in this directory
          unlock | u </path/to/symmetrical/key>: unlock the git crypt using the provided symmetrical key";;
      *) echo "Error: unknown command $1" && exit 1;;
    esac
  '';
}
