{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.emacs;
in
{
  options.modules.emacs = {
    enable = mkEnableOption "Emacs modules";
    src = mkOption {
      type = types.path;
      default = ../../config/emacs.org;
      description = "The source path for the emacs configuration file.";
    };
    target = mkOption {
      type = types.str;
      default = ".emacs.d";
      description = "The target path, prepended with /home/user, to write the configuration to.";
    };
    lsp.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable language server (LSP) support & packages.";
    };
  };

  config = mkIf cfg.enable {
    home.file."${cfg.target}/emacs.org" = {
      source = cfg.src;
      onChange = ''
        emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "${cfg.target}/emacs.org")'
      '';
    };

    programs.emacs = {
      enable = true;
      extraPackages = (
        epkgs:
          (
            with epkgs; [
              use-package
              evil
              org
              lsp-mode
              lsp-ui
              nord-theme
              nyan-mode
              zone-nyan
              multi-vterm
              rustic
              nix-mode
              nixpkgs-fmt
              dashboard
              projectile
              restart-emacs
              magit
              which-key
              free-keys
              ledger-mode
              haskell-mode
              lsp-haskell
              lua-mode
            ]
          )
      );
    };

    services.emacs.enable = true;

    home.packages = mkIf cfg.lsp.enable (
      with pkgs; [
        rust-analyzer
        rnix-lsp
        ledger
        ledger-web
        haskellPackages.haskell-language-server
      ]
    );
  };
}
