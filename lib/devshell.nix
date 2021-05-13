{ pkgs }:

with pkgs;

{
  frmt = writeShellScriptBin "frmt" ''
    fd .nix | xargs nixpkgs-fmt
  '';
}
