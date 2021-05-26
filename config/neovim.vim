" Correct all spelling errors with C-L
set spell
set spelllang=en_gb
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Auto-save on LaTeX files
autocmd BufNewFile,BufRead *.tex set updatetime=100
autocmd BufNewFile,BufRead *.tex autocmd CursorHold,CursorHoldI * update

" Add an underline under the cursor in Startify
autocmd User Startified setlocal cursorline

" Add mouse support so we can scroll and select
set mouse=a

" Ugh pressing :q takes so long
nnoremap q :q<CR>
nnoremap <C-X> :x<CR>

" Rust!
noremap <leader><T> <esc>:RustTest<CR>
noremap <C-T> <esc>:RustTest!<CR>