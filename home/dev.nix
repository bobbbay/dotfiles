{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.profiles.development;

  # We need to grab latexmk from CTAN
  latexmk = with pkgs;
    (texlive.combine { inherit (texlive) scheme-small latexmk; });
in {
  options.profiles.development = {
    enable = mkEnableOption "Development profile";

    # TODO
    neovim = {
      enable = mkEnableOption "Neovim";
      latex.enable = mkEnableOption "LaTeX support";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      neovim = {
        enable = true;

        extraConfig = builtins.readFile ../config/init.vim;
        plugins = with pkgs.vimPlugins; [
          vim-nix # Support for writing Nix expressions in Vim.
          { # Support for *TeX files
            plugin = vimtex;
            config = ''
              let g:tex_flavor='latex'            " Set LaTeX as our flavour
              let g:vimtex_view_method='zathura'  " Use Zathura to view
              let g:vimtex_quickfix_mode=0
              set conceallevel=1                  " Conceal actual Tex text unless we are on that line
              let g:tex_conceal='abdmg'
            '';
          }
          { # Support for snippets
            plugin = ultisnips;
            config = ''
               let g:UltiSnipsExpandTrigger = '<tab>'
               let g:UltiSnipsJumpForwardTrigger = '<tab>'
              let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
            '';
          }
          vim-snippets # Default snippets
          { # Start-up page
            plugin = vim-startify;
            config = "let g:startify_change_to_vcs_root = 0";
          }
        ];

        viAlias = true;
        vimAlias = true;
      };

      zathura = {
        enable = true;
        extraConfig = builtins.readFile ../config/zathura.rc;
      };

      git = {
        enable =
          true; # Git is already installed globally from within our root config
        aliases = { stat = "status"; };
        # signing.key = null;
        # signByDefault = true;
        userEmail = "abatterysingle@gmail.com";
        userName = "Bobbbay";
      };
    };
    
    home.packages = [
      latexmk # Compile LaTeX + vimtex compiler support
    ];
  };
}
