{
  version ? "dev",
  lib,
  stdenv,
  emacs,
}:
stdenv.mkDerivation {
  pname = "tangled-configurations";
  inherit version;
  src = ./.;

  buildInputs = [emacs];

  buildPhase = ''
    cp $src/* .
    emacs --batch -Q \
      -l org \
      emacs.org \
      -f org-babel-tangle
  '';

  dontUnpack = true;

  installPhase = ''
    install -D -t $out *.el
  '';
}
