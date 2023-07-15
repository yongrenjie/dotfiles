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
    FastFoldUpdate!
endfunction
autocmd BufWritePre <buffer> silent call RecalcFolds()

" Import short forms
iabbrev <buffer> inp import numpy as np
iabbrev <buffer> impl import matplotlib.pyplot as plt
iabbrev <buffer> iplt import matplotlib.pyplot as plt
iabbrev <buffer> isns import seaborn as sns
iabbrev <buffer> ipd import pandas as pd
