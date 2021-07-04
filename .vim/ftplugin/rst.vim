let maplocalleader='\'
let g:asyncrun_open=20

let g:abbot_cite_style="acs"
let g:abbot_cite_format="rst"

" Find the Sphinx source directory, i.e. the directory that conf.py is in.
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

" Trigger a Sphinx dirhtml build.
function! BuildSphinx()
    let fname = FindSourceDir()
    if !empty(fname)
        let build_cmd = "sphinx-build -a -E -b dirhtml " .. fname .. " " .. fname .. "/dirhtml"
        call asyncrun#run("", {}, build_cmd)
    else
        echohl ErrorMsg | echo "BuildSphinx(): Sphinx source directory not found" | echohl None
    endif
endfunction
nnoremap <buffer> <localleader>m :call BuildSphinx()<CR>

" Replacement for gf.
function! OpenFile()
    " The matplotlib plot directive in Sphinx resolves relative paths
    " relative to the source directory, which means that when we type 'gf'
    " we need to make sure that the path is being called relative to the
    " source directory.
    " However, all other directives resolve relative paths relative to the
    " working directory... and absolute paths are relative to the source
    " directory. Argh!
    " First, we figure out whether it's an absolute or relative path.
    let cfile = expand("<cfile>")
    if cfile[0] == "/"
        let pathtype = "absolute"
        let cfile = cfile[1:]  " strip off the leading /
    else
        let pathtype = "relative"
    endif
    " Next, figure out if it's a plot or exec directive. If so just turn
    " pathtype back into absolute, since we want to resolve vs the source dir.
    if match(getline("."), ".. plot::") > -1 || match(getline("."), ".. exec::") > -1
        let pathtype = "absolute"
    endif
    " Now, we can open the file directly if it's meant to be a relative path.
    if pathtype == "relative"
        execute "tabedit " .. cfile
        return
    else
        let sourcedir = FindSourceDir()
        if !empty(sourcedir)
            execute "tabedit" .. sourcedir .. "/" .. expand("<cfile>")
        else
            echohl ErrorMsg | echo "OpenFile(): Sphinx source directory not found" | echohl None
        endif
    endif
endfunction
" Override default gf functionality.
nnoremap <buffer> gf :call OpenFile()<CR>


function! ExpandHeading()
    let length  = len(getline(line(".") - 1))
    let curline = getline(".")
    if empty(curline)
        let char = "="
    else
        let char = curline[0]
    endif
    execute "normal cc" .. repeat(char, length)
endfunction

inoremap <silent> <C-L><C-L> <Esc>:call ExpandHeading()<CR>A
