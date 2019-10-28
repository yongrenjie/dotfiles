set number
set autoindent
set hidden
filetype off
syntax on

" Show as much of the last line as possible, instead of @@@@@
set display+=lastline
" Make search (/ and ?) case-insensitive except when capital letters are
" present
set ignorecase
set smartcase

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

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" nice colour schemes
Plugin 'dikiaap/minimalist'
Plugin 'NLKNguyen/papercolor-theme'
" tomorrow-night is manually installed in ~/.vim/colors
" MATLAB syntax highlighting
Plugin 'raingo/vim-matlab'
" Python syntax highlighting
Plugin 'yongrenjie/python-syntax'
" LaTeX
Plugin 'lervag/vimtex'
" LaTeX - define mhchem environments as math to avoid incorrect error highlighting
" taken from https://superuser.com/q/852150/671733
au FileType tex syn region texMathZoneZ matchgroup=texStatement start="\\ce{"  start="\\cf{" matchgroup=texStatement end="}" end="%stopzone\>"   contains=@texMathZoneGroup
" LaTeX - ignore indentation for refsection environment
let g:vimtex_indent_ignored_envs=['refsection']
" Targets
Plugin 'wellle/targets.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'dhruvasagar/vim-open-url'
let g:python_highlight_all=1
let g:python_highlight_space_errors=0
call vundle#end()

" Fancy commands
command Hiss below term ++rows=10 python3
command IHiss below term ++rows=10 ipython
command Python below term ++rows=10 python3 %
command IPython below term ++rows=10 ipython %
command Pdflatex !latexmk % -pdf
" use !Doi2biblatex 10.1021/acs.orglett.9b00971 (or !Doi 10.1021/acs.orglett.9b00971, faster) to put the correct citation into the buffer
command -nargs=1 Doi2biblatex r !doi2biblatex.py <f-args>

filetype plugin indent on
set t_Co=256
set background=dark
colorscheme PaperColor
set shiftwidth=4
set tabstop=4
set expandtab

" Correct indent style for SE citation manager
:au BufEnter ~/citation/*.js :set expandtab!

" Correct indent style for TopSpin Python programmes
:au BufEnter ~/ps-opt/ts/*.py :set expandtab!
:au BufEnter ~/ps-opt/ts/*.py :set ts=8
:au BufEnter ~/ps-opt/ts/*.py :set sw=8

" Auto-detect TopSpin AU programmes as being in C
:au BufEnter /opt/topspin4.0.7/exp/stan/nmr/au/src/* :set filetype=c
