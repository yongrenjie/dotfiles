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

" Searching in vim.
" Make search (/ and ?) case-insensitive except when capital letters are present
set ignorecase
set smartcase
" incsearch settings. copied from :h incsearch
set incsearch
augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" gf: open the file in a new tab
nnoremap gf :tabedit <cfile><CR>

" Text motions for lines, cf. https://vi.stackexchange.com/q/6101/
xnoremap il g_o^
onoremap il :normal vil<CR>
xnoremap al $o^
onoremap al :normal val<CR>

" Leader key
nnoremap <Space> <Nop>
let mapleader=" "

" Vim-pulse
" Uncomment this to make it only highlight the search pattern.
" By default it highlights the entire line
" let g:vim_search_pulse_mode='pattern'

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

" Status line
set laststatus=2 " enables lightline
set noshowmode " disables the default insert
let g:lightline = {'colorscheme': 'one'}

" Colour scheme stuff
set termguicolors
packadd! onedark.vim
colorscheme onedark
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
    " Tab is reserved for VimCompletesMe.
    let g:UltiSnipsExpandTrigger="<C-S>"
endif

" Enable FastFold for all files
let g:fastfold_minlines=0

if !exists("au_loaded")
    let au_loaded = 1
    " Correct indent style for SE citation manager
    autocmd BufEnter ~/citation/*.js :set expandtab!
    " autocmd to detect TopSpin AU programmes as being in C
    autocmd BufEnter /opt/topspin4.0.9/exp/stan/nmr/au/src/* :set filetype=c
    autocmd BufEnter ~/noah-nmr/au/* :set filetype=c
    autocmd BufEnter ~/gennoah/processing/au/* :set filetype=c
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


" Set tex flavour. Normally I'd put this in /ftplugin/tex.vim, but vimtex
" nowadays complains on every file if this isn't set.
let g:tex_flavor = 'latex'


" Expand DOI function. The actual bindings should be implemented in
" ftplugin/ft.vim.
function ExpandDOI(type)
let doi = expand("<cWORD>")
echo "expanding DOI " .. doi .. "..."
python3<<EOF
import vim
from cygnet import cite
# get the citation
doi = vim.eval('expand("<cWORD>")')
try:
    citation = cite(doi, type=vim.eval('a:type'))
    citation = citation.replace("'", "''")
except Exception as e:
    citation = "error"
vim.command("let citation='{}'".format(citation))
EOF
if citation != "error"
    let lineno = line(".")
    " twiddle with empty lines before citation
    if !empty(trim(getline(line(".") - 1)))
        let x = append(line(".") - 1, "")
        let lineno += 1
    endif
    " replace the line with the citation
    put =citation | redraw
    " twiddle with empty lines after citation
    if !empty(trim(getline(line(".") + 1)))
        let x = append(line("."), "")
    endif
    execute lineno .. " delete _"
else
    redraw | echohl ErrorMsg | echo "invalid DOI " .. doi | echohl None
endif
endfunction
