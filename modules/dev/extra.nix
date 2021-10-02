{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.dev.extra;
  latexmk = with pkgs; (texlive.combine { inherit (texlive) scheme-small latexmk; });
in

{
  options.modules.dev.extra = {
    enable = mkEnableOption "Extra configuration";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      home.packages = with pkgs; [
        latexmk # Compile LaTeX + vimtex compiler support
        virtmanager # Vital virtualisation.
        stack # Haskell
        ghc # Haskell
        rofi # Pick the app
        alacritty # Unlimited power/terminal
        jetbrains.idea-ultimate
        gcc
        dotnet-sdk_5
        offlineimap
        notmuch
        unstable.idris2
        # clang
        binutils
        sqlite
        postman
        file

        git-lfs1
        gitAndTools.gitui

        (
          with fenix;
          combine (
            with default; [
              cargo
              cargo-edit
              cargo-cross
              clippy-preview
              rust-std
              rustc
              rustfmt-preview

              latest.rust-src
            ]
          )
        )
      ];
    };
  };
}
