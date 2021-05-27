{ config, pkgs, lib, home, ... }:
with lib;
let
  cfg = config.modules.emacs;
in
{
  options.modules.emacs = {
    enable = mkEnableOption "Emacs modules";
    src = mkOption {
      type = types.path;
      default = ../config/emacs;
      description = "The source path for the emacs configuration directory.";
    };
    target = mkOption {
      type = types.str;
      default = ".emacs.d";
      description = "The target path, prepended with /home/user, to write the configuration to.";
    };
    lsp.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the Language Server packages.";
    };
  };

  config = mkIf cfg.enable {
    home.file = {
      "${cfg.target}" = {
        source = cfg.src;
        recursive = true;
      };
    };

    programs.emacs = {
      enable = true;
      extraPackages = (epkgs:
        (with epkgs; [
          evil
          use-package
          lsp-mode
          lsp-ui
          nord-theme
          nyan-mode
          zone-nyan
          emacs-libvterm
          rustic
          nix-mode
          nixpkgs-fmt
          dashboard
        ])
      );
    };

    services.emacs.enable = true;

    home.packages = mkIf cfg.lsp.enable (with pkgs; [
        rust-analyzer
        rnix-lsp
      ]);
  };
}
