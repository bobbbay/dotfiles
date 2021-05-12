{ suites, ... }:

{
  imports = [ ../profiles/cli ../profiles/dev ];

  config.cachix.enable = true;
  programs.git.signing = {
    key = "8CBE57D50985EADF";
    signByDefault = true;
  };

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
}
