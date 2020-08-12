set number
set autoindent
set hidden
filetype plugin indent on
syntax on
set backspace=indent,eol,start
set splitright
set splitbelow

" Indentation style
set shiftwidth=4
set tabstop=4
set expandtab

" Timeout after hitting Esc (in ms)
set ttimeoutlen=50
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

" Quickfix
set switchbuf=useopen
nnoremap <leader>] :cnext<CR>	
nnoremap <leader>[ :cprevious<CR>

" Fzf shortcuts
nnoremap <leader>f :Files ~<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>r :Rg<CR>

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
" And make that the default if we're in tmux or jlab
if exists("$TMUX") || !empty("$JUPYTER_SERVER_ROOT")
    set clipboard=unnamed,unnamedplus
endif

" Status line
set laststatus=2 " enables lightline
set noshowmode " disables the default insert
let g:lightline = {'colorscheme': 'PaperColor'}

" Colour scheme stuff
colorscheme PaperColor
set t_ut=""
" Detect light/dark mode automatically.
" Also set terminal escape codes for italic text.
if stridx(system("uname"), "Darwin") != -1  " if MacOS
    let g:tar_cmd="/usr/local/bin/gtar"   " allow editing tarballs, requires homebrew gnu-tar
    set t_ZH=[3m
    set t_ZR=[23m
    if stridx(system("defaults read -g AppleInterfaceStyle 2>/dev/null"), "Dark") == -1
        set background=light
    else
        if !empty($JUPYTER_SERVER_ROOT)
            set t_Co=256  " By default it launches as 8 colors.
            set background=light
        else
            set background=dark
        endif
    endif
else  " somewhere else, e.g. WSL
    set background=dark
endif

" Load UltiSnips if python3 is enabled.
if has('python3')
    packadd ultisnips
endif

" Enable FastFold for all files
let g:fastfold_minlines=0

if !exists("au_loaded")
    let au_loaded = 1
    " Correct indent style for SE citation manager
    autocmd BufEnter ~/citation/*.js :set expandtab!
    " autocmd to detect TopSpin AU programmes as being in C
    autocmd BufEnter /opt/topspin4.0.9/exp/stan/nmr/au/src/* :set filetype=c
endif

" Shortcut for highlighting test
command Hitest :source $VIMRUNTIME/syntax/hitest.vim
" Show syntax highlighting groups for word under cursor
" all over the Internet, but e.g. https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
nnoremap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" Shortcut for executing Python code snippets
nnoremap <leader>xp :w !python
vnoremap <leader>xp :w !python

" Set tex flavour. Normally I'd put this in /ftplugin/tex.vim, but vimtex
" nowadays complains on every file if this isn't set.
let g:tex_flavor = 'latex'
