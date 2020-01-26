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
    execute 'r !doi2biblatex.py "'.doi.'"'
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
vnoremap <leader><leader>p "*p
vnoremap <leader><leader>P "*P
vnoremap <leader><leader>y "*y
vnoremap <leader><leader>Y "*Y
nnoremap <leader><leader>p "*p
nnoremap <leader><leader>P "*P
nnoremap <leader><leader>y "*y
nnoremap <leader><leader>Y "*Y

" Status line
set laststatus=2 " enables lightline
set noshowmode " disables the default insert
let g:lightline = {'colorscheme': 'PaperColor'}

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
" Set TeX flavour. This is needed for tex.snippets to work.
" Without this, :set ft? will give 'plaintex'; with it, :set ft? will give
" 'tex'. See :h tex_flavor for more info
let g:tex_flavor='latex'
" Comment string for snippets
autocmd FileType snippets setlocal commentstring=#\ %s
" PDF viewer for vimtex in WSL
let s:uname = system("uname")
if s:uname == "Linux\n"
    let g:vimtex_view_general_viewer = "okular"
endif

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
endif

" Show syntax highlighting groups for word under cursor
" all over the Internet, but e.g. https://jordanelver.co.uk/blog/2015/05/27/working-with-vim-colorschemes/
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
