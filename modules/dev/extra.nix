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
        rofi # Pick the app
        alacritty # Unlimited power/terminal
        gcc
        dotnet-sdk_5
        unstable.idris2
        binutils
        sqlite
        postman
        file
        texlab texlive.combined.scheme-full

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
