{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    slack
    blender
    flameshot
    bat
    wget
    nix-index
  ];
}
