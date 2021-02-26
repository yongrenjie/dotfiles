function! ExpandHeading()
    let length  = len(getline(line(".") - 1))
    let curline = getline(".")
    if empty(curline)
        let char = "="
    else
        let char = curline[0]
    endif
    execute "normal cc" .. repeat(char, length)
endfunction

inoremap <C-L><C-L> <Esc>:call ExpandHeading()<CR>o
