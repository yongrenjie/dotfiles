" Basic settings {{{1
set number                            " Enable line numbers
set autoindent                        " Automatically indent when starting a new line
set hidden                            " Don't unload buffers when switching to another
filetype plugin indent on             " Enable filetype-specific plugins and indent scripts
syntax on                             " Enable syntax highlighting
set backspace=indent,eol,start        " Make Backspace work at the start of a line
set splitright splitbelow             " Default sides for split windows.
set display+=lastline                 " Show as much of the last line as possible
set shiftwidth=4 tabstop=4 expandtab  " Default indentation style
set ttimeoutlen=50                    " Timeout after hitting Esc, fixes a common tmux issue
set ignorecase smartcase              " Make search case-insensitive if only small letters
set incsearch                         " Enable incremental search
augroup vimrc-ishl                    " This autocmd is from `:h incsearch`.
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END
" }}}1

" Basic mappings {{{1
" Leader key
nnoremap <Space> <Nop>
let mapleader=" "
" Syntax sync -- for long files where vim gets confused
nnoremap <leader>ssf :syntax sync fromstart<CR>
" Open directory containing current file {{{2
function! OpenCurDir()
    let l:dir = expand("%:p:h")
    if !empty(l:dir)
        execute "e" . l:dir
    endif
endfunction
nnoremap <leader>ls :call OpenCurDir()<CR>
" }}}2
" Easy system clipboard access with <Space><Space> {{{2
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
" }}}2
" Text motions for lines, cf. https://vi.stackexchange.com/q/6101/ {{{2
xnoremap il g_o^
onoremap il :normal vil<CR>
xnoremap al $o^
onoremap al :normal val<CR>
" }}}2
" }}}1

" Basic autocmds {{{1
" Recognise TopSpin AU programmes as being C.
autocmd BufEnter /opt/topspin4.1.0/exp/stan/nmr/au/src/* :set filetype=c
autocmd BufEnter ~/gennoah/scripts/au/* :set filetype=c
" }}}1

" Plugin settings and mappings {{{1
" netrw
let g:netrw_liststyle=1         " Use ls -al style by default
let g:netrw_localrmdir='rm -r'  " Allow netrw to delete nonempty directories
" Vim-LSP setup {{{2
let g:lsp_preview_autoclose=1
" let g:lsp_log_file = expand('~/vim-lsp.log')
" Function to scroll in popup windows using C-j and C-k {{{3
function! ScrollPopup(val)
    let winid = popup_list()
    if winid == [] | return 0 | endif
    let pos = popup_getpos(winid[0])
    " If there's no scrollbar visible, exit.
    if pos.scrollbar == 0 | return 0 | endif
    " Set the first and last lines of the popup buffer.
    " https://fortime.ws/blog/2020/03/14/20200312-01/
    let new_firstline = pos.firstline + a:val
    let new_lastline = str2nr(trim(win_execute(winid[0], "echo line ('$')")))
    if new_firstline < 1
        let new_firstline = 1
    elseif pos.lastline + a:val > new_lastline
        let new_firstline = new_firstline - a:val + new_lastline - pos.lastline
    endif
    call popup_setoptions(winid[0], #{
        \ firstline: new_firstline,
        \ minwidth: pos.core_width,
        \ maxwidth: pos.core_width + 1,
        \ }) " Constrain min and maxwidth so that they don't change when scrolling.
endfunction
" }}}3
" Haskell Language Server {{{3
if executable('haskell-language-server-wrapper')
    au User lsp_setup call lsp#register_server(#{
        \ name: 'hls',
        \ cmd: ['haskell-language-server-wrapper', '--lsp'],
        \ allowlist: ['haskell', 'lhaskell'],
        \ })
endif " }}}3
" Microsoft Python Language Server {{{3
if executable('mspyls')
    au User lsp_setup call lsp#register_server(#{
        \ name: 'mspyls',
        \ cmd: ['mspyls'],
        \ allowlist: ['python'],
        \ root_uri: {server_info->lsp#utils#path_to_uri(
        \       lsp#utils#find_nearest_parent_file_directory(
        \           lsp#utils#get_buffer_path(), [
        \             'setup.py',
        \             'setup.cfg',
        \             'pyproject.toml',
        \             'requirements.txt',
        \             '.git/'
        \          ]))},
        \ initialization_options: #{
        \     analysisUpdates: v:true,
        \     asyncStartup: v:true,
        \     displayOptions: {},
        \     interpreter: #{
        \         properties: #{
        \             InterpreterPath: systemlist("which python")[0],
        \             UseDefaultDatabase: v:true,
        \             Version: '3.9',
        \         },
        \     },
        \ },
        \ workspace_config: #{
        \   python: #{
        \     analysis: #{
        \       errors: [],
        \       info: [],
        \       disabled: [],
        \     },
        \   },
        \ },
        \ })
endif " }}}3
" Functions to handle location window for diagnostics. {{{3
function! UpdateDiagnostics()      " This is meant to be called automatically.
    let winid = win_getid()
    let loclist_isopen = filter(getwininfo(), 'v:val.loclist == 1') != []
    if loclist_isopen
        LspDocumentDiagnostics
    call win_gotoid(winid)
    else
        return
    endif
endfunction
function! ToggleLocationWindow()
   " This is meant to be called manually. It toggles the visibility of the
   " location window, except when there are no diagnostics, in which case it
   " does nothing.
    let winid = win_getid()
    let loclist_isopen = filter(getwininfo(), 'v:val.loclist == 1') != []
    if loclist_isopen
        lclose
    else
        if filter(lsp#get_buffer_diagnostics_counts(), "v:val > 0") != {}
            LspDocumentDiagnostics
        else
            echomsg "No diagnostics found"
        endif
    endif
    call win_gotoid(l:winid)
endfunction " }}}3
function! s:check_back_space() abort " *** Check if the previous character is a space. {{{3
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction " }}}3
function! EnableLSPMappings() " *** Things to enable if LSP is available. {{{3
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=number
    " Close preview window with K again. (I think Esc only works in neovim)
	let g:lsp_preview_doubletap = [function('lsp#ui#vim#output#closepreview')]
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer>gd        <Plug>(lsp-definition)
    nmap <buffer>K         <Plug>(lsp-hover)
    nmap <buffer><leader>[ :lprevious<CR>
    nmap <buffer><leader>] :lnext<CR>
    " Scroll in popup windows.
    nnoremap <silent><C-J> :call ScrollPopup(3)<CR>
    nnoremap <silent><C-K> :call ScrollPopup(-3)<CR>
    " Autocompletion using asyncomplete.vim
    let g:asyncomplete_auto_popup = 0
    inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ asyncomplete#force_refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    inoremap <expr><CR>    pumvisible() ? asyncomplete#close_popup() : "\<C-]>\<CR>"
    " Manage diagnostics.
    autocmd User lsp_diagnostics_updated :call UpdateDiagnostics()
    nnoremap <silent><buffer><leader>d :call ToggleLocationWindow()<CR>
endfunction " }}}3
augroup lsp_install " *** Turn on LSP. {{{3
    autocmd!
    autocmd User lsp_buffer_enabled call EnableLSPMappings()
augroup END " }}}3
" }}}2
set laststatus=2 noshowmode  " Enable lightline and turn off Vim's default '--INSERT--' prompt.
let g:tex_flavor='latex'     " Vimtex complains if this isn't in .vimrc.
let g:fastfold_minlines=0    " Enable FastFold for all files
" Fzf shortcuts {{{2
nnoremap <leader>f :Files ~<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>r :Rg<CR>
" }}}2
" Load UltiSnips if python3 is enabled {{{2
if has('python3')
    packadd ultisnips
    " Tab is reserved for VimCompletesMe.
    let g:UltiSnipsExpandTrigger="<C-S>"
endif
" }}}2
" Load VimCompletesMe if we *aren't* using a language server {{{2
let s:lsp_filetypes=['haskell', 'lhaskell', 'python']
if index(s:lsp_filetypes, &filetype) == -1
    packadd! VimCompletesMe
endif
" }}}2
" Disable indentLine by default, but make a mapping to toggle it {{{2
let g:indentLine_enabled=0
nnoremap <silent> <leader>i :IndentLinesToggle<CR>
" }}}2
" }}}1

" Colour scheme management {{{1
" Enable truecolor if available.
if $TERM_PROGRAM ==# "iTerm.app"
    set termguicolors
endif
set t_ut=""
" Detect light/dark mode automatically.
" Also set terminal escape codes for italic text.
if stridx(system("uname"), "Darwin") != -1  " if MacOS
    let g:tar_cmd="/usr/local/bin/gtar"   " allow editing tarballs, requires homebrew gnu-tar
    set t_ZH=[3m
    set t_ZR=[23m
    if $TERMCS ==# "light"
        set background=light

        " colorscheme PaperColor
        " let g:lightline = {'colorscheme': 'PaperColor'}

        let g:one_allow_italics = 1
        colorscheme one
        let g:lightline = {'colorscheme': 'one'}

        " Vim-search-pulse default colours are meant for dark mode and look
        " horrendous on light mode, so we need to override them.
        let g:vim_search_pulse_color_list = ['#e4e4e4', '#dadada', '#d0d0d0', '#c6c6c6', '#bcbcbc'] 
    else
        set background=dark

        packadd! onedark.vim
        let g:onedark_terminal_italics = 1
        colorscheme onedark
        let g:lightline = {'colorscheme': 'one'}
    endif
else  " somewhere else, e.g. WSL
    set background=light
    colorscheme PaperColor
    let g:lightline = {'colorscheme': 'PaperColor'}
endif
" Shortcut for highlighting test
command Hitest :source $VIMRUNTIME/syntax/hitest.vim
" Show syntax highlighting groups for word under cursor
nnoremap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
"}}}1

" ExpandDOI function {{{1
" The actual bindings should be implemented in ftplugin/ft.vim.
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
    " if !empty(trim(getline(line(".") - 1)))
    "     let x = append(line(".") - 1, "")
    "     let lineno += 1
    " endif
    " replace the line with the citation
    put =citation | redraw
    " twiddle with empty lines after citation
    " if !empty(trim(getline(line(".") + 1)))
    "     let x = append(line("."), "")
    " endif
    execute lineno .. " delete _"
else
    redraw | echohl ErrorMsg | echo "invalid DOI " .. doi | echohl None
endif
endfunction " }}}1

" vim: foldmethod=marker
