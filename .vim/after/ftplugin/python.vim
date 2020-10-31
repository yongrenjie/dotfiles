function RecalcFolds()
    call SimpylFold#Recache()
    FastFoldUpdate
endfunction
autocmd BufWritePre <buffer> call RecalcFolds()
