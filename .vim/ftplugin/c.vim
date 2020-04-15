" Fast compilation of C programmes
function! CompileC()
    let fname = expand("%")
    silent let compile_output = system("make " . fname)
    if v:shell_error == 0
        echo "Compile successful"
    else " failed
        echo compile_output
    endif
endfunction
nnoremap <leader>cc :call CompileC() <CR>
