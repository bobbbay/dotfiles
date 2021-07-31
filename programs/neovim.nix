{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.bobos.programs.neovim;
in
{
  options.bobos.programs.neovim = {
    enable = mkEnableOption "Emacs modules";
    src = mkOption {
      type = types.path;
      default = ../config/vim.org;
      description = "The source path for the emacs configuration file.";
    };
    target = mkOption {
      type = types.str;
      default = ".config/nvim";
      description = "The target path, prepended with /home/user, to write the configuration to.";
    };
  };

  config = mkIf cfg.enable {
    home.file."${cfg.target}/vim.org" = {
      source = cfg.src;
      onChange = ''
        # rm -rf ${cfg.target}
        # mkdir ${cfg.target}
        # mkdir ${cfg.target}/lua
        mkdir lua
        emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "./vim.org")'
        echo `pwd`
      '';
    };

    programs.neovim.enable = true;
  };
}
