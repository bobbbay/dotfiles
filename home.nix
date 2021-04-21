{ config, pkgs, home, ... }:

with import <nixpkgs> {};
with lib;

#let
#  core = import ./home/core.nix { config = config; pkgs = pkgs; home = home; };
#in
{
  imports = [ ./home/core.nix ];
}
