{ config, ... }:

{
  imports = [ ../../profiles/cli ../../profiles/dev ];

  config.profiles.cli.enable = true;
  config.profiles.dev.enable = true;
}
