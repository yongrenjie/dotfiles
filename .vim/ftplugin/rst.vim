" setlocal tabstop=3
" setlocal shiftwidth=3
setlocal nosmartindent

let maplocalleader='\'
let g:asyncrun_open=20

function! FindSourceDir()
    " Need two layers of expand(), see :h expand()
    let f = expand(expand("%:p"))
    while f != "/"
        " Check if conf.py exists. If so, return.
        if filereadable(f .. "/conf.py")
            return f
        else
            let f = fnamemodify(f, ":h")
        endif
    endwhile
    " If reached here, conf.py was not found
    return ""
endfunction

function! BuildSphinx()
    let fname = FindSourceDir()
    if !empty(fname)
        let build_cmd = "sphinx-build -a -E -b dirhtml " .. fname .. " " .. fname .. "/_build"
        call asyncrun#run("", {}, build_cmd)
    else
        echohl ErrorMsg | echo "BuildSphinx(): Sphinx source directory not found" | echohl None
    endif
endfunction
nnoremap <buffer> <localleader>m :call BuildSphinx()<CR>

function! OpenFile()
    " 'include' and similar directives in Sphinx resolve relative paths
    " relative to the source directory, which means that when we type 'gf'
    " we need to make sure that the path is being called relative to the
    " source directory.
    let fname = FindSourceDir()
    if !empty(fname)
        execute "tabedit" .. fname .. "/" .. expand("<cfile>")
    else
        echohl ErrorMsg | echo "OpenFile(): Sphinx source directory not found" | echohl None
    endif
endfunction
" Override default gf functionality.
nnoremap <buffer> gf :call OpenFile()<CR>
