{ pkgs, ... }:

{
  programs = {
    alacritty = {
      enable = true;
      settings = import ../../other/bobbbay/alacritty.nix;
    };

    chromium.enable = true;
  };
}
