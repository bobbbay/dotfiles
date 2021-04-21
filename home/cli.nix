{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.profiles.cli;
in {
  options.profiles.cli = {
    enable = mkEnableOption "CLI Utilities";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep-all # ripgrep for everything: PDFs, E-Books, etc.
      bingrep # grep through binaries
      bat # A cat clone with wings (syntax highlighting)
      fd # A simple, fast and friendly alternative to find
      hyperfine # Benchmark your executables!
      tokei # Like wc but better
      exa # ls for cool people
      cachix # Cache them binaries
      gitAndTools.gitui # UI for Git!
      nodePackages.insect # Calculator REPL
    ];
  };
}
