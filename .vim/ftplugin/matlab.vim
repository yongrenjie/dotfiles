function! GetMatlabPath()
    let pathdef_m_file = $matlabroot . "/toolbox/local/pathdef.m"
    " parse the file: see readfile()
    let path_dirs = []
    return path_dirs
endfunction

function! SearchMatlabPath(function_name)
    " search inside each of s:matlab_path: see findfile()
    return ""
endfunction

function GotoDefinition()
    let word = expand("<cword>")
    let defining_file = SearchMatlabPath(word)
    if empty(defining_file)
        echo "Definition not found"
    else
        echo defining_file
    endif
endfunction

" Initialise the path
let s:matlab_path = GetMatlabPath()
nnoremap <silent> gd :call GotoDefinition()<CR>

set foldmethod=indent
