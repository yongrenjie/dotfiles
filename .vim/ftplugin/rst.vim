setlocal tabstop=3
setlocal shiftwidth=3
setlocal nosmartindent

let maplocalleader='\'
let g:asyncrun_open=10
nnoremap <localleader>m :AsyncRun make clean && make html <CR>