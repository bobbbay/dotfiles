{ pkgs }:

with pkgs;

{
  lint = writeShellScriptBin "lint" ''
    set -euo pipefail
    fd --color=never .nix | xargs nixfmt
  '';
}
