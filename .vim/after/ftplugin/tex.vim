nnoremap <buffer><silent> <localleader>t :call VimtexToggleTocAndReturn()<CR>

function! VimtexToggleTocAndReturn() abort
    let l:nr = win_getid()
    VimtexTocToggle
    call win_gotoid(l:nr)
endfunction
