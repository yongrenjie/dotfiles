" Fast compilation of C programmes
function! CompileKNR()
    let fname = expand("%")
    let pname = expand("%:r")
    silent let compile_output = system("cc " . fname . " -o " . pname . " -Wall -ansi")
    if v:shell_error == 0
        echo "Compile successful"
    else " failed
        echo compile_output
    endif
endfunction
nnoremap <leader>cc :call CompileKNR() <CR>
