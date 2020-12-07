let g:vim_dir = '$HOME/.config/nvim/'

let s:plug_path = g:vim_dir . "/autoload/plug.vim"
if empty(glob(s:plug_path))
    execute 'silent !curl -fLo ' . s:plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall
endif

call plug#begin(s:plug_path . "plugged")

" The ultimate status line, period.
Plug 'itchyny/lightline.vim'

" For wakatime
Plug 'wakatime/vim-wakatime'

" A sexy startup screen
" TODO: Replace with custom repository
Plug 'mhinz/vim-startify'

" Tabs.
Plug 'Bobbbay/itsanfingtab'

" Multiple cursors interest you?
Plug 'mg979/vim-visual-multi'

" Some cool icons I'll neve use
Plug 'powerline/fonts', { 'dir': g:vim_dir . 'autoload/plug.vimplugged/fonts', 'do': './install.sh' }

" As fuzzy as a tribble
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" LSP time
Plug 'neoclide/coc.nvim'

" To install an LSP:
" :CocInstall coc-json coc-clangd coc-cmake coc-css coc-flutter coc-go
" coc-fsharp coc-java coc-python coc-sh coc-texlab coc-vimlsp coc-yaml

" For an absolutely awesome workspace
Plug 'thaerkh/vim-workspace'

" Indents indents lines indents
Plug 'thaerkh/vim-indentguides'

" Comfy motion indeed
Plug 'yuttie/comfortable-motion.vim'

call plug#end()

" Enable the legend of the mouse
set mouse=a

" Map jj to esc, kk to w, hh to x
inoremap jj <esc>
inoremap kk <esc>:w<cr>
inoremap hh <esc>:x<cr>

" Toggle Workspace mode on leader + s
nnoremap <leader>s :ToggleWorkspace<cr>

" Workspace configs
let g:workspace_autosave_always = 1

" Tab sizes
set tabstop=4
set shiftwidth=4
set expandtab

" Programming language tab sizes
autocmd FileType c setlocal tabstop=2

let g:lightline =
    \ {
    \ 'colorscheme': 'seoul256',
    \ }
