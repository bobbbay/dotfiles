{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop.term.extra;
in

{
  options.modules.desktop.term.extra = {
    enable = mkEnableOption "terminal tools";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      home.packages = with pkgs; [
        ripgrep-all # ripgrep for everything: PDFs, E-Books, etc.
        bingrep # grep through binaries
        bat # A cat clone with wings (syntax highlighting)
        fd # A simple, fast and friendly alternative to find
        hyperfine # Benchmark your executables!
        tokei # Like wc but better
        fzf # fuzzy finding
        nodePackages.insect # Calculator REPL
        skim # fzf in Rust
        google-chrome
        slack
        xplr # The hackable file explorer
        graphviz

        unstable.exa # ls but better
        unstable.bottom # system monitoring go brrr
      ];

      programs.zoxide.enable = true;
    };
  };
}
