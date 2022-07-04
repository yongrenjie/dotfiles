function! SaveCompileRun() abort
    w
    execute('below term ++rows=20 g++ -o ' . expand('%:p:r') . ' ' . expand('%:p') . '; ' . expand('%:p:r'))
endfunction
nnoremap <buffer><silent> <localleader>m :call SaveCompileRun()<CR>
