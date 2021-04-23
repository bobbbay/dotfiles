{ pkgs }:

with pkgs;

{
  useCaches = writeShellScriptBin "use-caches" ''
    cachix use -O . nix-community
    cachix use -O . bobbbix
  '';

  lint = writeShellScriptBin "lint" ''
    set -euo pipefail
    fd --color=never .nix | xargs nixfmt
  '';
}
