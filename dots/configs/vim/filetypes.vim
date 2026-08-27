augroup School21_style
    autocmd!

    " systems
    autocmd BufNewFile,BufRead *.c,*.cpp setlocal
        \ tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        \ nowrap

    " scripts
    autocmd BufNewFile,BufRead *.sh,*.bash setlocal
        \ tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        \ nowrap
    autocmd BufReadPost *
        \ if getline(1) =~ '^#!.*\(sh\|bash\)'                          |
        \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        \ nowrap                                                        |
        \ endif

augroup END
augroup Google_style
    autocmd!

    " system
    autocmd BufNewFile,BufRead *.rs setlocal
        \ tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        \ nowrap

    " application
    autocmd BufNewFile,BufRead *.py,*.go setlocal
        \ tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        \ nowrap
    autocmd BufReadPost *
        \ if getline(1) =~ '^#!.*python'                                |
        \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        \ nowrap                                                        |
        \ endif

    " web
    autocmd BufNewFile,BufRead *.html,*.css,*.js,*.ts setlocal
        \ tabstop=2 shiftwidth=2 softtabstop=2 expandtab
        \ nowrap
    autocmd BufReadPost * 
        \ if getline(1) =~ '^#!.*\(node\|deno\|bun\)'                   |
        \ setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
        \ nowrap                                                        |
        \ endif

    " script
    autocmd BufNewFile,BufRead *.vim setlocal
        \ tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        \ wrap

augroup END
augroup Linux_style
    autocmd!

    " scripts
    autocmd BufNewFile,BufRead *.lua,Makefile,*.mk setlocal
        \ tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab
        \ nowrap
    autocmd BufReadPost *
        \ if getline(1) =~ '#!.*\(lua\)'                                |
        \ setlocal tabstop=8 shiftwidth=8 softtabstop=4 noexpandtab
        \ nowrap                                                        |
        \ endif

augroup END
augroup GNU_style
    autocmd!

    " system
augroup other_style
    autocmd!

    autocmd BufNewFile,BufRead *.nix,*.json,*.yaml setlocal
        \ tabstop=2 shiftwidth=2 softtabstop=2 expandtab
        \ wrap

    autocmd BufNewFile,BufRead *.md,*.txt setlocal
        \ textwidth=110 wrap

augroup END
