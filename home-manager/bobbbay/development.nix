{ pkgs, ... }:

{
  home.packages = [
    pkgs.git pkgs.gnumake pkgs.nasm pkgs.qemu
  ];

  programs = {
    emacs.enable = true;
  };
}
