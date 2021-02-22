{ pkgs, ... }:

{
  imports = [
    ./base.nix
    ./xorg.nix
    ./development.nix
  ];
}
