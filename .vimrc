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
" Open directory containing current file
nnoremap <leader>ls :Explore<CR>
" Change current directory in window
function! LcdHere() abort
    let curdir = expand('%:p:h')
    execute 'lcd ' . curdir
    echo 'changed local working dir to ' . curdir
endfunction
nnoremap <leader>lcd :call LcdHere()<CR>
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
" <leader>[] to jump around quickfix / location list {{{2
function! QFLocListPrevNext(next) abort
    " a:next should be +1 if going forward and -1 if going backwards
    let l:winfo = getwininfo()

    " Try quickfix list
    let l:qf_open = !empty(filter(l:winfo, 'v:val.quickfix'))
    if l:qf_open
        if a:next == +1 | cnext
        elseif a:next == -1 | cprev | endif
        return
    end

    " Try location list
    let l:loc_open = !empty(filter(l:winfo, 'v:val.loclist'))
    if l:loc_open
        if a:next == +1 | lnext
        elseif a:next == -1 | lprev | endif
        return
    end
endfunction
nnoremap <silent> <leader>[ :call QFLocListPrevNext(-1)<CR>
nnoremap <silent> <leader>] :call QFLocListPrevNext(+1)<CR>
" }}}2
" }}}1

" Basic autocmds {{{1
" Recognise TopSpin AU programmes as being C.
autocmd BufEnter /opt/topspin4.1.3/exp/stan/nmr/au/src/* :set filetype=c
autocmd BufEnter ~/genesis/scripts/au/* :set filetype=c
" Detect thesis files
autocmd BufReadPre ~/dphil/thesis/*.tex :let b:is_dphil_thesis=1
" }}}1

" Grep setup {{{1
" Slightly modified from
" https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
if executable('rg')
    let &grepprg = 'rg --vimgrep '
    " Grep in current directory, or other specified location
    function RunGrep(...)
        " Note that the errorformat here is specialised to rg's output.
        let l:old_efm = &errorformat
        let &errorformat = '%f:%l:%c:%m'
        cgetexpr system(join([&grepprg] + a:000, ' '))
        let &errorformat = l:old_efm
        cwindow
    endfunction
    command! -nargs=+ -complete=file Grep call RunGrep(<f-args>)
    " Grep within open buffers
    function RunGrepInOpenBuffers(...)
        let l:old_efm = &errorformat
        let &errorformat = '%f:%l:%c:%m'
        let l:buffers = getbufinfo()
                    \ ->map({_, val -> shellescape(val.name)})
                    \ ->filter({_, val -> !empty(val)})
        let l:command = join([&grepprg] + a:000 + l:buffers, ' ')
        cgetexpr system(l:command)
        let &errorformat = l:old_efm
        cwindow
    endfunction
    command! -nargs=+ Bgrep call RunGrepInOpenBuffers(<f-args>)
endif
" }}}1

" Automatic parentheses generation {{{1
" Usage: put the line
"     inoremap <expr> <C-L><C-L> MkMatchparenMap()
" in whichever ftplugin file you want to use this in
function! MkMatchparenMap() abort
    let l:open = getline('.')[-1:]
    if l:open == '{'
        let l:close = '}'
    elseif l:open == '['
        let l:close = ']'
    elseif l:open == '('
        let l:close = ')'
    else | return '' | endif
    return "\<CR>" . l:close . "\<Esc>O"
endfunction " }}}1

" Function to get the top-level git directory {{{1
function! GitTopLevel() abort
    silent let output = system('git rev-parse --show-toplevel')
    return v:shell_error ? '' : trim(output)
endfunction
let g:git_top_level = GitTopLevel()
" }}}1

" Plugin settings and mappings (except LSP) {{{1
packadd! matchit
" abbotsbury.vim
if executable('abbot')
    let g:abbot_use_git_email = 1
    let g:abbot_use_default_map = 0
    nmap <silent> <leader>e <plug>AbbotExpandDoi
else
    let g:abbot_enabled = 0
end
" matlab-utils
if !empty($MATLAB_ROOT)
    let g:matlab_root = $MATLAB_ROOT
endif
" netrw
let g:netrw_liststyle = 1       " Use ls -al style by default
let g:netrw_localrmdir = 'rm -r'  " Allow netrw to delete nonempty directories
set laststatus=2 noshowmode     " Enable lightline and turn off Vim's default '--INSERT--' prompt.
let g:fastfold_minlines = 0     " Enable FastFold for all files
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
" }}}2
" Disable indentLine by default, but make a mapping to toggle it {{{2
let g:indentLine_enabled = 0
function! ToggleIndentLine() abort
    let g:indentLine_enabled = 1
    IndentLinesEnable
endfunction
nnoremap <silent> <leader>ii :call ToggleIndentLine()<CR>
" }}}2
" }}}1

" LSP setup {{{1
if stridx(system("uname"), "Darwin") != -1  " if MacOS
    let g:my_lsp_plugin = 'vim-lsp'
else
    let g:my_lsp_plugin = 'none'
endif
let g:my_lsp_filetypes = ['haskell', 'lhaskell', 'python',
            \ 'typescript', 'javascript', 'rust']
function! VimrcInitialiseLSP() abort
    if match(g:my_lsp_filetypes, &filetype) == -1 | return | endif
    if g:my_lsp_plugin == 'vim-lsp'
    " vim-lsp setup {{{2
        packadd vim-lsp
        packadd asyncomplete.vim
        packadd asyncomplete-lsp.vim
        let g:lsp_preview_autoclose = 1
        " Haskell Language Server {{{3
        let g:hls_debug = 1    " Turn on for debugging output
        if executable('haskell-language-server-wrapper')
            let l:hls_cmd = ['haskell-language-server-wrapper', '--lsp']
            if g:hls_debug
                call extend(l:hls_cmd, ['--debug', '--logfile', '/tmp/hls.log'])
            endif
            au User lsp_setup call lsp#register_server(#{
                \ name: 'hls',
                \ cmd: ['haskell-language-server-wrapper', '--lsp', '--debug', '--logfile', '/tmp/hls.log'],
                \ root_uri: {server_info->lsp#utils#path_to_uri(
                \     lsp#utils#find_nearest_parent_file_directory(
                \         lsp#utils#get_buffer_path(),
                \         ['.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml', '.git'],
                \     ))},
                \ allowlist: ['haskell', 'lhaskell'],
                \ })
        endif " }}}3
        let g:python_language_server='mspyls'   " or 'pyright'
        " Pyright {{{3
        if executable('pyright-langserver') && g:python_language_server == 'pyright'
            au User lsp_setup call lsp#register_server(#{
                        \ name: 'pyright-langserver',
                        \ cmd: ['pyright-langserver', '--stdio'],
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
                        \ workspace_config: {
                        \     'python': {
                        \         'analysis': {
                        \             'useLibraryCodeForTypes': v:true
                        \             },
                        \         },
                        \     },
                        \ })
        endif
        " }}}3
        " Microsoft Python Language Server {{{3
        if executable('mspyls') && g:python_language_server == 'mspyls'
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
        " TypeScript Language Server {{{3
        if executable('typescript-language-server')
            au User lsp_setup call lsp#register_server(#{
                \ name: 'typescript-language-server',
                \ cmd: ['typescript-language-server', '--stdio'],
                \ allowlist: ['typescript', 'typescriptreact', 'javascript'],
                \ root_uri: {server_info->lsp#utils#path_to_uri(
                \       lsp#utils#find_nearest_parent_file_directory(
                \           lsp#utils#get_buffer_path(), [
                \             '.git/',
                \             'tsconfig.json',
                \          ]))},
                \ })
        endif " }}}3
        " Rust Analyzer {{{3
        if executable('rust-analyzer')
            au User lsp_setup call lsp#register_server({
                        \   'name': 'Rust Language Server',
                        \   'cmd': {server_info->['rust-analyzer']},
                        \   'whitelist': ['rust'],
                        \   'initialization_options': {
                            \     'cargo': {
                                \       'loadOutDirsFromCheck': v:true,
                                \     },
                                \     'procMacro': {
                                    \       'enable': v:true,
                                    \     },
                                    \   },
                                    \ })
        endif " }}}3
        " Functions to handle location window for diagnostics. {{{3
        function! UpdateDiagnostics()      " This is meant to be called automatically.
            let winid = win_getid()
            let loclist_isopen = filter(getwininfo(), 'v:val.loclist == 1') != []
            if loclist_isopen
                lclose
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
            if loclist_isopen  " was open
                lclose
            else               " wasn't open
                LspDocumentDiagnostics
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
            nmap <buffer>gr        <Plug>(lsp-rename)
            nmap <buffer>K         <Plug>(lsp-hover)
            nmap <buffer><leader>a <Plug>(lsp-code-action)
            " Scroll in popup windows.
            nnoremap <buffer><silent><expr><C-J> lsp#scroll(+3)
            nnoremap <buffer><silent><expr><C-K> lsp#scroll(-3)
            " Autocompletion using asyncomplete.vim
            let g:asyncomplete_auto_popup = 0
            inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ asyncomplete#force_refresh()
            inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
            inoremap <expr><CR>    pumvisible() ? asyncomplete#close_popup() : "\<C-]>\<CR>"
            " Manage diagnostics.
            autocmd User lsp_diagnostics_updated :noautocmd :call UpdateDiagnostics()
            nnoremap <silent><buffer><leader>d :noautocmd :call ToggleLocationWindow()<CR>
        endfunction " }}}3
        augroup lsp_install " *** Turn on LSP. {{{3
            autocmd!
            autocmd User lsp_buffer_enabled call EnableLSPMappings()
        augroup END " }}}3
    " }}}2
    endif
endfunction
augroup vimrc_lsp
    autocmd FileType * call VimrcInitialiseLSP()
augroup END
" }}}1

" Colour scheme management {{{1
" Enable truecolor if available. This is a bit of a hacky check. Ideally we
" would check for $COLORTERM; however, this environment variable is not passed
" over SSH. Also, a quick check of the terminals I currently use show that the
" ones that don't support truecolor (macOS Terminal.app, Windows Terminal WSL)
" are labelled 'xterm-256colors', and those that do (macOS iTerm2) are
" labelled 'xterm'. Since $TERM is passed over SSH, this will reliably work.
if $TERM ==# "xterm"
    set termguicolors
    if $TERMCS ==# "light"
        set background=light
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
set t_ut=""
" Detect light/dark mode automatically.
" Also set terminal escape codes for italic text.
if stridx(system("uname"), "Darwin") != -1  " if MacOS
    let g:tar_cmd = "/usr/local/bin/gtar"   " allow editing tarballs, requires homebrew gnu-tar
    set t_ZH=[3m
    set t_ZR=[23m
end
" Shortcut for highlighting test
command Hitest :source $VIMRUNTIME/syntax/hitest.vim
" Show syntax highlighting groups for word under cursor
nnoremap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack") | return | endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
"}}}1

" vim: foldmethod=marker
