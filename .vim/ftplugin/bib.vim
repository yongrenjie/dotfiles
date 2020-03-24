" Expand DOI to BibLaTeX entry
function ExpandDOIBib()
    let doi = expand("<cWORD>")
    let bib = system('doi2biblatex.py "' . doi . '"')
    if v:shell_error == 0
        normal! diW
        put =bib
        normal! =ap}{dd
    else " failed
        echohl WarningMsg | echo bib | echohl None 
    endif
endfunction
nnoremap <leader>ex :call ExpandDOIBib() <CR>
