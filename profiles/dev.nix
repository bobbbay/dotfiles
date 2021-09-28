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
    modules.neomacs.enable = true;
    bobos.programs.neovim.enable = false;

    programs = {
      neovim = {
        package = with pkgs; neovim-nightly;
        viAlias = true;
        vimAlias = true;
      };

      zathura = {
        enable = true;
        extraConfig = builtins.readFile ../config/zathura.rc;
      };

      git = {
        enable = true; # Git is already installed globally from within our root config
        aliases.stat = "status";
        userEmail = "abatterysingle@gmail.com";
        userName = "Bobbbay";
        signing = {
          signByDefault = true;
          key = null; # Automatically figured out
        };
        lfs.enable = true;
      };

      gpg.enable = true;

      tmux.enable = true;

      direnv = {
        enable = true;
        nix-direnv = {
          enable = true;
          enableFlakes = true;
        };
      };
    };

    services = {
      gpg-agent = {
        enable = true;
        pinentryFlavor = "qt";
      };
    };

    home.file.".config/alacritty/alacritty.yml" = {
      source = ../config/alacritty.yml;
    };

    home.file.".git/areg.conf".text = ''
      [user]
        name = Areg
        email = me@areg.dev
        signingKey = 4A0B1F8C91322407
    '';

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
      git-crypt # Encrypt those git files!
      virtmanager # Vital virtualisation.
      stack # Haskell
      ghc # Haskell
      rofi # Pick the app
      alacritty # Unlimited power/terminal
      dude
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
