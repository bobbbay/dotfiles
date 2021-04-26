{ config, pkgs, lib, ... }:

{
  imports = [ ../../profiles/cli ];
  config.profiles.cli.enable = true;
}
