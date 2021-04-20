{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cmake cairo next xorg.xclock
  ];
}
