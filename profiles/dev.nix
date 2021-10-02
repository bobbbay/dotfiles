{ config, lib, pkgs, ... }:

# Regular development tools

with builtins;
with lib;
let
  cfg = config.profiles.dev;
  # We need to grab latexmk from CTAN
  latexmk = with pkgs;
    (texlive.combine { inherit (texlive) scheme-small latexmk; });
in
{
  options.profiles.dev = {
    enable = lib.mkOption {
      description = "Enable development tools.";
      type = with lib.types; bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".offlineimaprc".source = ../crypt/offlineimap.rc;
    home.file.".authinfo".source = ../crypt/authinfo;

    # [TODO]: Remove username-specific config (maybe with XDG dirs)
    home.file.".notmuch-config".text = ''
      [database]
      path=/home/bobbbay/mail

      [new]
      tags=unread;inbox
    '';

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
}
