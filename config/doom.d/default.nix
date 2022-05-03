{ version ? "dev", lib, stdenv, emacs }:

stdenv.mkDerivation {
  pname = "emacs-tangle-configuration";
  inherit version;
  src = lib.sourceByRegex ./. [ "config.org"
                                "config.el" "init.el" "packages.el"
                              ];

  buildInputs = [emacs];

  buildPhase = ''
    cp $src/* .
    # Tangle org files
    emacs --batch -Q \
      -l org \
      config.org \
      -f org-babel-tangle
  '';

  dontUnpack = true;

  installPhase = ''
    install -D -t $out *.el
  '';
}
