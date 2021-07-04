{ config, pkgs, lib, ... }:

# CLI utilities

let
  cfg = config.modules.cli;
in
{
  options.modules.cli.enable = lib.mkOption {
    description = "Enable CLI tools.";
    type = with lib.types; bool;
    default = false;
  };

  config = lib.mkIf config.modules.cli.enable {
    home.packages = with pkgs; [
      ripgrep-all # ripgrep for everything: PDFs, E-Books, etc.
      bingrep # grep through binaries
      bat # A cat clone with wings (syntax highlighting)
      fd # A simple, fast and friendly alternative to find
      hyperfine # Benchmark your executables!
      tokei # Like wc but better
      nodePackages.insect # Calculator REPL
      skim # fzf in Rust
      google-chrome
      slack

      (nerdfonts.override { fonts = [ "Iosevka" ]; })

      unstable.exa # ls but better
      unstable.bottom # system monitoring go brrr

      xplr # The hackable file explorer
    ];

    fonts.fontconfig.enable = true;

    programs.bash = {
      enable = true;
      shellAliases = {
        nrs = "sudo nixos-rebuild switch";
        ls = "exa --long --icons --header --git";
        sk = ''rga --files | \sk --preview="bat {} --color=always"'';
        d = "dude";
        ".." = "cd ..";
      };
    };
  };
}