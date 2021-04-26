{ config, pkgs, lib, ... }:

let cfg = config.profiles.cli;

in {
  options.profiles.cli.enable = lib.mkOption {
    description = "Enable CLI tools.";
    type = with lib.types; bool;
    default = false;
  };

  config = lib.mkIf config.profiles.cli.enable {
    home.packages = with pkgs; [
      ripgrep-all # ripgrep for everything: PDFs, E-Books, etc.
      bingrep # grep through binaries
      bat # A cat clone with wings (syntax highlighting)
      fd # A simple, fast and friendly alternative to find
      hyperfine # Benchmark your executables!
      tokei # Like wc but better
      # exa # ls for cool people
      nodePackages.insect # Calculator REPL
      skim # fzf in Rust

      comma # Run any command, anywhere
      xplr # The hackable file explorer
      bobtools # Custom useful binaries

      unstable.exa
    ];

    programs.bash = {
      enable = true;
      shellAliases = {
        nrs = "sudo nixos-rebuild switch";
        ls = "exa --long --icons --header --git";
        sk = ''rga --files | \sk --preview="bat {} --color=always"'';
        ".." = "cd ..";
      };
      bashrcExtra = ''
        export DISPLAY=$(grep nameserver /etc/resolv.conf | awk '{print $2}'):0.0
        export TZ='America/Toronto';
      '';
    };
  };
}
