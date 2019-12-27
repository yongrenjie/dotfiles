set number
set autoindent
set hidden
filetype plugin indent on
syntax on
set backspace=indent,eol,start

" Show as much of the last line as possible, instead of @@@@@
set display+=lastline
" Make search (/ and ?) case-insensitive except when capital letters are
" present
set ignorecase
set smartcase

" Text motions for lines, cf. https://vi.stackexchange.com/q/6101/
xnoremap il g_o^
onoremap il :normal vil<CR>
xnoremap al $o^
onoremap al :normal val<CR>

" Leader key
nnoremap <Space> <Nop>
let mapleader=" "

function ExpandDOIBib()
    let doi = expand("<cWORD>")
    normal! diW
    execute 'r !doi2biblatex.py' doi
    normal! =ap}{dd
    " Edge case where it produces an extra line
    if line(".") == 1
        if getline(".") !~ '\S'
            normal! dd
        endif
    endif
endfunction

function! OpenDOIURL()
    let firstline = line("'{")
    let lastline = line("'}")
    let i = firstline
    while i <= lastline
        let tline = getline(i)
        let doi = matchstr(tline, 'doi = {\zs.*\ze}')
        if !empty(doi)
            execute "OpenURL https://doi.org/" . doi
            break
        endif
        let i = i + 1
    endwhile
endfunction

nnoremap <leader>ex :call ExpandDOIBib() <CR>
nnoremap <leader>op :call OpenDOIURL() <CR>

" Easy system clipboard yank/paste
vnoremap ;;p "*p
vnoremap ;;P "*P
vnoremap ;;y "*y
vnoremap ;;Y "*Y
nnoremap ;;p "*p
nnoremap ;;P "*P
nnoremap ;;y "*y
nnoremap ;;Y "*Y

" Fancy commands
command Pdflatex !latexmk % -pdf
" use !Doi2biblatex 10.1021/acs.orglett.9b00971 (or !Doi 10.1021/acs.orglett.9b00971, faster) to put the correct citation into the buffer
command -nargs=1 Doi2biblatex r !doi2biblatex.py <f-args>

" Colour scheme stuff
" set t_Co=256
" The above is not needed if $TERM=xterm-256color in bash, vim
" should read it automatically
colorscheme PaperColor
set background=dark
set t_ut=""
" Turn on Python syntax highlighting
let g:python_highlight_all=1
" Remove automatic indentation for certain LaTeX environments
" cmdline and script are user-defined envs for the SBM comp chem tutorial...
let g:vimtex_indent_ignored_envs=['document', 'cmdline', 'script']

" Indentation style
set shiftwidth=4
set tabstop=4
set expandtab

if !exists("au_loaded")
    let au_loaded = 1
    " Correct indent style for SE citation manager
    au BufEnter ~/citation/*.js :set expandtab!
    " Auto-detect TopSpin AU programmes as being in C
    au BufEnter /opt/topspin4.0.7/exp/stan/nmr/au/src/* :set filetype=c
    au BufEnter ~/ps-opt/timerev/au/* :set filetype=c
    au BufEnter ~/noah-nmr/au/* :set filetype=c
    " Other verbatim environments in LaTeX
    au filetype tex syntax region texZone start='\\begin{cmdline}' end='\\end{cmdline}'
    au filetype tex syntax region texZone start='\\begin{script}' end='\\end{script}'
endif
