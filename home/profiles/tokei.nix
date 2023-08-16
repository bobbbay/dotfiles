{ pkgs, ...}: {
  home.packages = with pkgs; [ tokei ];
}
