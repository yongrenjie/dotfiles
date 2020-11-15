" Turn on syntax highlighting by python-syntax
let g:python_highlight_all=1
" Enable preview of folded docstrings
let g:SimpylFold_docstring_preview = 1

" PEP 8. Also helps with `gq`.
setlocal textwidth=79

let maplocalleader='\'
let $PYTHONUNBUFFERED=1
let g:asyncrun_open=10
nnoremap <buffer> <localleader>m :AsyncRun -raw python % <CR>

" Path to doq, for pydocstring
let g:pydocstring_doq_path = '/Users/yongrenjie/Library/Python/3.8/bin/doq'
let g:pydocstring_formatter = 'numpy'
nnoremap <buffer> <localleader>dd :Pydocstring <CR>

" import short forms.
iabbrev inp import numpy as np
iabbrev iplt import matplotlib.pyplot as plt
iabbrev isns import seaborn as sns
iabbrev ipg import penguins as pg
iabbrev ipd import pandas as pd
iabbrev inmrd from penguins.private import nmrd
iabbrev iandro from penguins.private import Andrographolide as Andro
iabbrev izolmi from penguins.private import Zolmitriptan as Zolmi

" User completion for directories in nmrd()
function! CompleteNMRD(findstart, base)
    if a:findstart  " equals 1 on first invocation, to locate the start of the word
        let line = getline('.')  " text on current line
        let pos = col('.') - 1   " current cursor column adjusted for 0-indexing
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
        return readdir($nmrd, {n -> match(n, a:base) == 0 && n[0] != '.'})
    endif
endfunction
setlocal completefunc=CompleteNMRD
