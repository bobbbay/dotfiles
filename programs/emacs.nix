{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.emacs;
  emacsPackages = (
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
        olivetti
        company
        flycheck
        yasnippet
        yasnippet-snippets
        general
        ibuffer-projectile
        undo-tree
        treemacs
        treemacs-evil
        treemacs-projectile
        lsp-treemacs
        treemacs-all-the-icons
        all-the-icons
        csharp-mode
        omnisharp
        tide
        ng2-mode
        company-quickhelp
        company-statistics
        notmuch
        dotnet
        ivy
        counsel
        swiper
        idris-mode
        one-themes
        evil-collection
        diminish
        delight
        multiple-cursors
        dap-mode
      ]
    )
  );
in
{
  options.modules.emacs = {
    enable = mkEnableOption "Emacs modules";
    src = mkOption {
      type = types.path;
      default = ../config/emacs.org;
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

    home.file."${cfg.target}/.extension/vscode/webfreak.debug/extension/out" = {
      source = pkgs.fetchFromGitHub {
        owner = "WebFreak001";
        repo = "code-debug";
        rev = "5151db04ee78063637cf273c1c1a75450a3cfc5e";
        sha256 = "WaywWMC1TGxhW0i+Oui/onTdnQgZd0BI3OpOl3A9Xa8=";
      };
    };

    programs.emacs = {
      enable = true;
      extraPackages = emacsPackages;
    };

    services.emacs = {
      enable = true;
      package = (pkgs.emacsWithPackages emacsPackages);
    };

    home.packages = mkIf cfg.lsp.enable (
      with pkgs; [
        rust-analyzer
        rnix-lsp
        ledger
        ledger-web
        haskellPackages.haskell-language-server
        omnisharp-roslyn
        nodejs
        nodePackages."@angular/cli"
        emacs-all-the-icons-fonts
        gdb
        lldb
      ]
    );
  };
}
