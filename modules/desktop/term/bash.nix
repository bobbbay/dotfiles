{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop.term.bash;
in

{
  options.modules.desktop.term.bash = {
    enable = mkEnableOption "Bash";
    bashrcExtra = mkOption {
      default = "";
      type = types.lines;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.bash = {
        enable = true;
        shellAliases = {
          nrs = "sudo nixos-rebuild switch";
          ls = "exa --long --icons --header --git --links --blocks --inode --grid";
          sk = ''rga --files | \sk --preview="bat {} --color=always"'';
          d = "dude";
          e = "emacsclient -c";
          ".." = "cd ..";
        };
        bashrcExtra = cfg.bashrcExtra;
      };

      programs.starship = {
        enable = true;
        settings = { };
      };
    };
  };
}
