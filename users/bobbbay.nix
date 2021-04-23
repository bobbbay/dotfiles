{ suites, ... }:

{
  imports = [ ../profiles/cli ../profiles/dev ];
  config.cachix.enable = true;
}
