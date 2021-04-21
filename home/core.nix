{ config, pkgs, home, ... }:

with import <nixpkgs> {};
with lib;

{
  imports = [
    ./cli.nix # Useful command-line utilities such as fd, tokei, hyperfine, etc.
    ./dev.nix # Development profile such as nvim, latexmk, etc.
  ];

  config.profiles.cli.enable = true;
  config.profiles.development.enable = true;
}
