setlocal tabstop=8
setlocal shiftwidth=8
setlocal softtabstop=8
setlocal noexpandtab
setlocal nowrap

if exists('+colorcolumn')
	setlocal colorcolumn=80
endif

" подсвечивает красным пробелы в конце строк
highlight ExtraWhitespace ctermbg=9 guibg=#BF616A
match ExtraWhitespace /\s\+$/

" убирает пробелы в конце строк при сохранени
autocmd BufWritePre <buffer> %s/\s\+$//e

