function! VimtexTocToggleAndReturn() abort
    let l:nr = win_getid()
    VimtexTocToggle
    " call win_gotoid(l:nr)
endfunction
nnoremap <buffer><silent> <localleader>t :call VimtexTocToggleAndReturn()<CR>


" Thesis-specific mappings {{{1
" These depend on the value of b:is_thesis, which is set in
" .vim/ftplugin/tex.vim. If you want to control when these are triggered, go
" there and change it.
function! s:after_thesis_mappings() abort
    " For debugging (if necessary)
    if 0 | echomsg 'Hi from after/ftplugin' | endif

    " Make custom mappings for vimtex TOC
    augroup thesis-after | au!
        " Make CR and Space behave similarly (i.e. don't close the ToC when
        " jumping). Normally, Space doesn't close it and CR closes it.
        autocmd User VimtexEventTocCreated nmap <buffer> <CR> <Space>
        " Make = behave like +, avoiding having to press Shift.
        autocmd User VimtexEventTocCreated nmap <buffer> = +
        " Make { and } move between chapters, [ and ] move between section
        autocmd User VimtexEventTocCreated nmap <buffer><silent> { ?\v^L0<CR>
        autocmd User VimtexEventTocCreated nmap <buffer><silent> } /\v^L0<CR>
        " Disable other mappings beginning with [ and ] to avoid the
        " ttimeoutlen lag (it's not like we're using them...)
        autocmd User VimtexEventTocCreated nunmap [z
        autocmd User VimtexEventTocCreated nunmap [%
        autocmd User VimtexEventTocCreated nunmap ]z
        autocmd User VimtexEventTocCreated nunmap ]%
        autocmd User VimtexEventTocCreated nmap <buffer><silent> [ ?\v^L[01]<CR>
        autocmd User VimtexEventTocCreated nmap <buffer><silent> ] /\v^L[01]<CR>
    augroup END

    " Disable automatic folding
    setlocal foldmethod=marker

    " Compile and open ToC automatically if it was the first file opened
    if expand('%') =~# 'thesis.tex' && len(getbufinfo()) == 1
        VimtexCompile
        VimtexTocToggle
    endif
endfunction

if exists('b:is_thesis')   " set in .vim/ftplugin/tex.vim
    call s:after_thesis_mappings()
endif
" }}}1


" vim: foldmethod=marker
