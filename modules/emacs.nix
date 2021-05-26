{ pkgs, home, ... }:

{
  home.file = {
    ".emacs.d" = {
      source = ../config/emacs;
      recursive = true;
    };
  };
}
