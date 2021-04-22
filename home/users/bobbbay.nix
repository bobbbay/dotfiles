{ config, pkgs, home, ... }:

with import <nixpkgs> { };
with lib;

{
  imports = [
    ../cli.nix  # Useful command-line utilities such as fd, tokei, hyperfine, etc.
    ../dev.nix  # Development profile such as nvim, latexmk, etc.
    ../misc.nix # Misc packages
  ];

  config.profiles.cli.enable = true;
  config.profiles.development.enable = true;
  config.profiles.misc.enable = true;
}
