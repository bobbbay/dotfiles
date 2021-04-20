{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep-all # ripgrep for everything: PDFs, E-Books, etc.
    bingrep     # grep through binaries
    bat         # A cat clone with wings (syntax highlighting)
    fd          # A simple, fast and friendly alternative to find
    hyperfine   # Benchmark your executables!
    tokei       # Like wc but better
  ];
}
