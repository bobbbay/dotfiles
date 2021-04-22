{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "bobscripts";
  version = "0.1";
  src = ../../bin;
  builder = with pkgs; "${bash}/bin/bash";
  args = [ ./build.sh ];
  buildInputs = with pkgs; [ coreutils rustc ];
  system = builtins.currentSystem;
}
