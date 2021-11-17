let maplocalleader='\'
let g:asyncrun_open=20
let g:abbot_cite_style="acs"
let g:abbot_cite_format="rst"

" More vim-sandwich recipes {{{1
let b:sandwich_recipes = deepcopy(g:sandwich#default_recipes)
let b:sandwich_recipes += [
            \ {'buns': ['**', "**"], 'filetype': ['rst'], 'nesting': 0, 'input': ["b"]},
            \ {'buns': ['*', "*"], 'filetype': ['rst'], 'nesting': 0, 'input': ["i"]},
            \ {'buns': ['``', "``"], 'filetype': ['rst'], 'nesting': 0, 'input': ["t"]},
            \ ]
" }}}1

" Find the Sphinx source directory, i.e. the directory that conf.py is in.
function! FindSourceDir() " {{{1
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
endfunction " }}}1

" Trigger a Sphinx dirhtml build.
function! BuildSphinx() " {{{1
    let fname = FindSourceDir()
    if !empty(fname)
        let build_cmd = "sphinx-build -a -E -b dirhtml " .. fname .. " " .. fname .. "/dirhtml"
        call asyncrun#run("", {}, build_cmd)
    else
        echohl ErrorMsg | echo "BuildSphinx(): Sphinx source directory not found" | echohl None
    endif
endfunction " }}}1
nnoremap <buffer><silent> <localleader>m :call BuildSphinx()<CR>

" Replacement for gf.
function! OpenFile() " {{{1
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
endfunction " }}}1
nnoremap <buffer><silent> gf :call OpenFile()<CR>

" Automatically type heading lines.
function! ExpandHeading()  " {{{1
    let length  = len(getline(line(".") - 1))
    let curline = getline(".")
    if empty(curline)
        let char = "="
    else
        let char = curline[0]
    endif
    execute "normal cc" .. repeat(char, length)
endfunction " }}}1
inoremap <silent> <C-L><C-L> <Esc>:call ExpandHeading()<CR>A


" (For my DPhil notes only, on macOS only)
" Open the html file corresponding to the current rst file in the default web
" browser. Assumes that a HTTP server is being launched from
" ~/dphil/nbsphinx/dirhtml/ on port 5555 (as my 'dp1' bash alias does).
function! OpenHtmlFile() abort  " {{{1
    let cur_rst = expand('%:p:r')   " :p - full path, :r - no extension
    let nbs_dir = $HOME . '/dphil/nbsphinx'
    let address = substitute(cur_rst, '\V' . nbs_dir, 'http://localhost:5555', '') . '/'
    silent let v = system('open ' . address)
endfunction " }}}1
if expand('%:p') =~# 'dphil/nbsphinx'
    nnoremap <buffer><silent> <leader>o :call OpenHtmlFile()<CR>
endif

" vim: foldmethod=marker
