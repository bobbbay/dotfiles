{ pkgs, ... }:

{
  imports = [
    ./base.nix
    ./programs.nix
    ./xorg.nix
    ./development.nix
  ];
}
