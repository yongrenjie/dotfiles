set fillchars=fold:\ 
function! HtmlFoldText() abort
    return getline(v:foldstart)
endfunction
setlocal foldtext=HtmlFoldText()
