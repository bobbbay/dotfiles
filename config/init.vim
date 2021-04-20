" Correct all spelling errors with C-L
set spell
set spelllang=en_gb
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Auto-save
autocmd BufNewFile,BufRead *.tex set updatetime=100
autocmd BufNewFile,BufRead *.tex autocmd CursorHold,CursorHoldI * update

" Add an underline under the cursor in Startify
autocmd User Startified setlocal cursorline
