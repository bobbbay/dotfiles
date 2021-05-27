{ config, lib, pkgs, ... }:

with builtins;
with lib;
let
  cfg = config.profiles.dev;
  # We need to grab latexmk from CTAN
  latexmk = with pkgs;
    (texlive.combine { inherit (texlive) scheme-small latexmk; });
in
{
  options.profiles.dev = {
    enable = lib.mkOption {
      description = "Enable development tools.";
      type = with lib.types; bool;
      default = false;
    };
  };

  config = lib.mkIf config.profiles.dev.enable {
    programs = {
      neovim = {
        enable = true;
        package = with pkgs; neovim-nightly;
        extraConfig = builtins.readFile ../../config/neovim.vim;
        plugins = with pkgs.vimPlugins; [
          vim-nix # Support for writing Nix expressions in Vim.
          rust-vim # Who needs garbage collectors anyways?
          {
            # Support for *TeX files
            plugin = vimtex;
            config = ''
              let g:tex_flavor='latex'            " Set LaTeX as our flavour
              let g:vimtex_view_method='zathura'  " Use Zathura to view
              let g:vimtex_quickfix_mode=0
              set conceallevel=1                  " Conceal actual Tex text unless we are on that line
              let g:tex_conceal='abdmg'
            '';
          }
          {
            # Support for snippets
            plugin = ultisnips;
            config = ''
              let g:UltiSnipsExpandTrigger = '<tab>'
              let g:UltiSnipsJumpForwardTrigger = '<tab>'
              let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
            '';
          }
          vim-snippets # Default snippets
          {
            # Start-up page
            plugin = vim-startify;
            config = "let g:startify_change_to_vcs_root = 0";
          }
        ];

        viAlias = true;
        vimAlias = true;
      };

      zathura = {
        enable = true;
        extraConfig = builtins.readFile ../../config/zathura.rc;
      };

      git = {
        enable =
          true; # Git is already installed globally from within our root config
        aliases = { stat = "status"; };
        userEmail = "abatterysingle@gmail.com";
        userName = "Bobbbay";
        signing = {
          signByDefault = true;
          key = null;
        };
        lfs.enable = true;
      };

      gpg.enable = true;

      emacs = {
        enable = true;
        extraPackages = (epkgs:
        (with epkgs; [
          evil
	  use-package
	  lsp-mode lsp-ui
	  nord-theme
	  nyan-mode zone-nyan
	  emacs-libvterm
	  rustic
        ]));
      };

      tmux.enable = true;

      direnv = {
        enable = true;
        enableNixDirenvIntegration = true;
      };
    };

    services = {
      gpg-agent = {
        enable = true;
        pinentryFlavor = "qt";
      };
      emacs.enable = true;
    };

    home.packages = with pkgs; [
      latexmk # Compile LaTeX + vimtex compiler support
      git-crypt # Encrypt those git files!
      jetbrains.clion # Hi IDE I like Rust :flushed:
      virtmanager # Vital virtualisation.

      # For CLion
      gnumake
      gcc

      git-lfs1
      
      rnix-lsp
      rust-analyzer

      (with fenix;
      combine (with default; [
        cargo
        clippy-preview
        rust-std
        rustc
        rustfmt-preview

        latest.rust-src
      ]))
    ];
  };
}
