{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim-nightly git gnumake nasm qemu llvm patchelf gcc
    gcc-arm-embedded go
  ];

  imports = [
  #  ./programs/emacs.nix
  ];
}
