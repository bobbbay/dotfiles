{ config, pkgs, lib, ... }:

with lib;

let cfg = config.settings;
in {
  options.settings = {
    name = mkOption {
      default = "Bobbbay Bobbayan";
      type = with types; uniq str;
    };
    username = mkOption {
      default = "bobbbay";
      type = with types; uniq str;
    };
    email = mkOption {
      default = "abatterysingle@gmail.com";
      type = with types; uniq str;
    };
    wsl = mkOption {
      default = false;
      type = with types; uniq bool;
    };
    profile = mkOption {
      default = "";
      type = with types; uniq enum;
    };
  };

  config = {

  };
}
