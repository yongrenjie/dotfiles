set number
set autoindent
set hidden
filetype plugin indent on
syntax on
set backspace=indent,eol,start

" Indentation style
set shiftwidth=4
set tabstop=4
set expandtab

" Show as much of the last line as possible, instead of @@@@@
set display+=lastline
" Make search (/ and ?) case-insensitive except when capital letters are present
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

" Open papers quickly
function! OpenDOIURL()
    let firstline = line("'{")
    let lastline = line("'}")
    let i = firstline
    while i <= lastline
        let tline = getline(i)
        let doi = matchstr(tline, 'doi = {\zs.*\ze}')
        if !empty(doi)
            silent let output = system("open https://doi.org/" . doi)
            break
        endif
        let i = i + 1
    endwhile
endfunction
nnoremap <leader>op :call OpenDOIURL() <CR>

" Easy system clipboard access
vnoremap <leader><leader>p "*p
vnoremap <leader><leader>P "*P
vnoremap <leader><leader>y "*y
vnoremap <leader><leader>Y "*Y
vnoremap <leader><leader>c "*c
vnoremap <leader><leader>C "*C
vnoremap <leader><leader>d "*d
vnoremap <leader><leader>D "*D
vnoremap <leader><leader>s "*s
vnoremap <leader><leader>S "*S
nnoremap <leader><leader>p "*p
nnoremap <leader><leader>P "*P
nnoremap <leader><leader>y "*y
nnoremap <leader><leader>Y "*Y
nnoremap <leader><leader>c "*c
nnoremap <leader><leader>C "*C
nnoremap <leader><leader>d "*d
nnoremap <leader><leader>D "*D
nnoremap <leader><leader>s "*s
nnoremap <leader><leader>S "*S

" Status line
set laststatus=2 " enables lightline
set noshowmode " disables the default insert
let g:lightline = {'colorscheme': 'PaperColor'}

" Colour scheme stuff
colorscheme PaperColor
set background=dark
set t_ut=""

" Enable FastFold for all files
let g:fastfold_minlines=0

if !exists("au_loaded")
    let au_loaded = 1
    " Correct indent style for SE citation manager
    autocmd BufEnter ~/citation/*.js :set expandtab!
    " autocmdto-detect TopSpin AU programmes as being in C
    autocmd BufEnter /opt/topspin4.0.7/exp/stan/nmr/au/src/* :set filetype=c
    autocmd BufEnter ~/ps-opt/timerev/au/* :set filetype=c
    autocmd BufEnter ~/noah-nmr/au/* :set filetype=c
    autocmd BufWritePost ~/pypopt/pypopt.py :silent execute '! cp % $TS/py/user/pypopt.py'
    autocmd BufWritePost ~/pypopt/pypopt-be.py :silent execute '! cp % $TS/py/user/pypopt/pypopt-be.py'
endif

" Show syntax highlighting groups for word under cursor
" all over the Internet, but e.g. https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
nnoremap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
