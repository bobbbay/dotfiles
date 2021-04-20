{ pkgs, ... }:

{
  imports = [
    ./base.nix
    ./cli.nix
    ./dev.nix
  ];
}
