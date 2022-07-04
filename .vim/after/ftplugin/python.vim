let maplocalleader='\'

" PEP 8. Also helps with `gq`.
setlocal textwidth=79

" \m behaviour: run script without arguments
let $PYTHONUNBUFFERED=1
let g:asyncrun_open=15
nnoremap <silent><buffer> <localleader>m :w<CR>:AsyncRun -raw python %<CR>
nnoremap <silent><buffer> <localleader>q :call AsyncStopAndOrCloseQF()<CR>

" Terminate asyncrun job
function AsyncStopAndOrCloseQF()
    if g:asyncrun_status == "running"
        AsyncStop!
    endif
    cclose
endfunction

" Recalculate folds upon saving.
function RecalcFolds()
    call SimpylFold#Recache()
    FastFoldUpdate
endfunction
autocmd BufWritePre <buffer> call RecalcFolds()

" Import short forms
iabbrev <buffer> inp import numpy as np
iabbrev <buffer> impl import matplotlib.pyplot as plt
iabbrev <buffer> iplt import matplotlib.pyplot as plt
iabbrev <buffer> isns import seaborn as sns
iabbrev <buffer> ipg import penguins as pg
iabbrev <buffer> ipd import pandas as pd
iabbrev <buffer> inmrd from aptenodytes import nmrd
iabbrev <buffer> iandro from aptenodytes import Andrographolide as Andro
iabbrev <buffer> izolmi from aptenodytes import Zolmitriptan as Zolmi
iabbrev <buffer> igrami from aptenodytes import Gramicidin as Grami
iabbrev <buffer> pgsf pg.savefig('/Users/yongrenjie/Desktop/a.png', dpi=600)


" User completion for directories in nmrd()
function! CompleteNMRD(findstart, base)
    if a:findstart  " equals 1 on first invocation, to locate the start of the word
        let line = getline('.')  " text on current line
        let pos = col('.') - 2   " column just before the cursor, adjusted for 0-indexing
        " Exit silently and leave completion mode if nmrd() is not on the line
        if match(line, '\mnmrd()\s*/\s*[''"]') == -1
            return -3
        endif
        while pos > 0 && line[pos] !~ '\m[''"]'
            let pos = pos - 1
        endwhile
        return pos + 1  " start autocomplete from the character *after* the quote
    else  " a:findstart equals 0 on second invocation, must provide the autocomplete options
        " Get a list of results that begins with a:base
        " Reverse it so that the most recent appears at the top.
        return reverse(readdir($nmrd, {n -> match(n, a:base) == 0 && n[0] != '.'}))
    endif
endfunction
setlocal completefunc=CompleteNMRD
