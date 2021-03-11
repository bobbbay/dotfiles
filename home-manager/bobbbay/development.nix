{ pkgs, ... }:

{
  home.packages = with pkgs; [
    git gnumake nasm qemu llvm patchelf gcc
    gcc-arm-embedded go
  ];

  imports = [
  #  ./programs/emacs.nix
  ];
}
