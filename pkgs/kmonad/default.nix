{ pkgs, ... }:

let
  # config = import ./config.nix;
  pkgs = import <nixpkgs> { };
  kmonad = import ./kmonad.nix;
in
with pkgs.haskellPackages; callPackage kmonad { }
