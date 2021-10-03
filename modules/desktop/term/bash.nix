{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.desktop.term.bash;
in

{
  options.modules.desktop.term.bash = {
    enable = mkEnableOption "Bash";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.bash = {
        enable = true;
        shellAliases = {
          nrs = "sudo nixos-rebuild switch";
          ls = "exa --long --icons --header --git";
          sk = ''rga --files | \sk --preview="bat {} --color=always"'';
          d = "dude";
          e = "emacsclient -c";
          ".." = "cd ..";
        };
      };
    };
  };
}
