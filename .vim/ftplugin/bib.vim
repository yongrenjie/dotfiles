let g:abbot_bib_folding = 0
let g:vimtex_fold_bib_enabled = 1
set fillchars=fold:\ 

function! TimeBibFold() abort
    let start_time = reltime()
    call vimtex#fold#bib#init()
    echomsg 'initialised in time' . reltimestr(reltime(start_time))
    let start_time = reltime()
    call map(range(1, line('$')), 'foldlevel(v:val)')
    echomsg 'foldexprs calculated in' . reltimestr(reltime(start_time))
endfunction
