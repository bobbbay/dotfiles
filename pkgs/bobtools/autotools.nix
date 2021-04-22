pkgs: attrs:
  with pkgs;
  let defaultAttrs = {
    builder = "${bash}/bin/bash";
    args = [ ./build.sh ];
    baseInputs = [  ];
    buildInputs = [ coreutils ];
    system = builtins.currentSystem;
  };
  in
  derivation (defaultAttrs // attrs)
