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
