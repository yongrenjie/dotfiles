" Turn on syntax highlighting by python-syntax
let g:python_highlight_all=1
" Enable preview of folded docstrings
let g:SimpylFold_docstring_preview = 1

let maplocalleader='\'
let $PYTHONUNBUFFERED=1
let g:asyncrun_open=10
nnoremap <localleader>p :AsyncRun -raw python3 % <CR>
