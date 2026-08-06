" ====================================================================
"  ГОРЯЧИЕ КЛАВИШИ И ФУНКЦИИ (binds.vim)
" ====================================================================

" 1. Циклическое переключение режимов нумерации строк (F1)
function! ToggleNumberModes()
    if &number && !&relativenumber
        setlocal relativenumber nonumber
        echo "Relative numbers"
    elseif &relativenumber
        setlocal norelativenumber nonumber
        echo "Numbers OFF"
    else
        setlocal number norelativenumber
        echo "Absolute numbers"
    endif
endfunction

" 2. циклическое переключение режимов переноса строк (F2)
function! ToggleWrapModes()
    if !&wrap
        setlocal wrap nolinebreak
        echo "Wrap (by chars)"
    elseif &wrap && !&linebreak
        setlocal wrap linebreak
        echo "Wrap (by words)"
    else
        setlocal nowrap nolinebreak
        echo "No wrap"
    endif
endfunction


" бинды
nnoremap <F1> :call ToggleNumberModes()<CR>
vnoremap <F1> :<C-u>call ToggleNumberModes()<CR>
inoremap <F1> <Esc>:call ToggleNumberModes()<CR>a

nnoremap <F2> :call ToggleWrapModes()<CR>
vnoremap <F2> :<C-u>call ToggleWrapModes()<CR>
inoremap <F2> <Esc>:call ToggleWrapModes()<CR>a

