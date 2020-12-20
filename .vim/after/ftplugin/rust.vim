let maplocalleader='\'

nnoremap <buffer> <localleader>m 
            \ :below term ++shell ++close ++rows=15
            \ cargo run %; 
            \ echo --------------------------------------------------;
            \ read -p "Press Enter to close"<CR>
