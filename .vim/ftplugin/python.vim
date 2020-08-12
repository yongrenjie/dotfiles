" Turn on syntax highlighting by python-syntax
let g:python_highlight_all=1
" Enable preview of folded docstrings
let g:SimpylFold_docstring_preview = 1

" Maximum line width for `gq`.
set textwidth=79

let maplocalleader='\'
let $PYTHONUNBUFFERED=1
let g:asyncrun_open=10
nnoremap <localleader>p :AsyncRun -raw python % <CR>

" Path to doq, for pydocstring
let g:pydocstring_doq_path = '/Users/yongrenjie/Library/Python/3.8/bin/doq'
let g:pydocstring_formatter = 'numpy'
nnoremap <localleader>dd :Pydocstring <CR>
