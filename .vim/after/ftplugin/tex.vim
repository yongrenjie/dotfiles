function! VimtexTocToggleAndReturn() abort
    let l:nr = win_getid()
    VimtexTocToggle
    " call win_gotoid(l:nr)
endfunction
nnoremap <buffer><silent> <leader>t :call VimtexTocToggleAndReturn()<CR>

function! EqToAlign() abort
    " Modified from vimtex#env#toggle_star. Uses vimtex internals thus liable
    " to breaking! But that's a risk I'm willing to take
    let [l:open, l:close] = vimtex#env#get_surrounding('normal')
    if empty(l:open) | return | endif
    if l:open.name ==# 'equation'
        call vimtex#env#change(l:open, l:close, l:open.starred ? 'align*' : 'align')
    elseif l:open.name ==# 'align'
        call vimtex#env#change(l:open, l:close, l:open.starred ? 'equation*' : 'equation')
    endif
endfunction
nnoremap <buffer><silent> <leader>e :call EqToAlign()<CR>

" Thesis-specific mappings {{{1
" These depend on the value of b:is_thesis, which is set in
" .vim/ftplugin/tex.vim. If you want to control when these are triggered, go
" there and change it.
function! s:after_thesis_mappings() abort
    " For debugging (if necessary)
    if 0 | echomsg 'Hi from after/ftplugin' | endif

    " Mapping to reset my view
    nnoremap <silent><buffer> <leader>h :only<CR>:e ~/dphil/thesis/thesis.tex<CR>:call VimtexTocToggleAndReturn()<CR>

    " Make custom mappings for vimtex TOC
    augroup thesis-after | au!
        " Make CR and Space behave similarly (i.e. don't close the ToC when
        " jumping). Normally, Space doesn't close it and CR closes it.
        autocmd User VimtexEventTocCreated nmap <buffer> <CR> <Space>
        " Make = behave like +, avoiding having to press Shift.
        autocmd User VimtexEventTocCreated nmap <buffer> = +
        " Make { and } move between chapters, [ and ] move between section
        autocmd User VimtexEventTocCreated nmap <buffer><silent><nowait> { ?\v^L0<CR>
        autocmd User VimtexEventTocCreated nmap <buffer><silent><nowait> } /\v^L0<CR>
        " Disable other mappings beginning with [ and ] to avoid the
        " ttimeoutlen lag (it's not like we're using them...)
        " autocmd User VimtexEventTocCreated nunmap <buffer><silent> [z
        " autocmd User VimtexEventTocCreated nunmap <buffer><silent> [%
        " autocmd User VimtexEventTocCreated nunmap <buffer><silent> ]z
        " autocmd User VimtexEventTocCreated nunmap <buffer><silent> ]%
        autocmd User VimtexEventTocCreated nmap <buffer><silent><nowait> [ ?\v^L[01]<CR>
        autocmd User VimtexEventTocCreated nmap <buffer><silent><nowait> ] /\v^L[01]<CR>
    augroup END

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
