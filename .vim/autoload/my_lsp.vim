" LSP setup in Vim.
"
function! s:configure_lsp() abort
    if match(s:my_lsp_filetypes, &filetype) == -1 | return | endif
    if s:my_lsp_plugin == 'vim-lsp'
        packadd vim-lsp
        packadd asyncomplete.vim
        packadd asyncomplete-lsp.vim
        let g:lsp_preview_autoclose = 1
        " Haskell Language Server {{{3
        let s:hls_debug = 1    " Turn on for debugging output
        if executable('haskell-language-server-wrapper')
            let l:hls_cmd = ['haskell-language-server-wrapper', '--lsp']
            if s:hls_debug
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
        let s:python_language_server='mspyls'   " or 'pyright'
        " Pyright {{{3
        if executable('pyright-langserver') && s:python_language_server == 'pyright'
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
        if executable('mspyls') && s:python_language_server == 'mspyls'
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
        " clangd {{{3
        if executable('clangd')
            au User lsp_setup call lsp#register_server({
                        \ 'name': 'clangd',
                        \ 'cmd': {server_info->['clangd', '-background-index']},
                        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
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
        endfunction
        augroup lsp_install
            autocmd!
            autocmd User lsp_buffer_enabled call EnableLSPMappings()
        augroup END
    endif
endfunction


function! my_lsp#InitialiseLSP() abort
    if stridx(system("uname"), "Darwin") != -1  " if MacOS
        let s:my_lsp_plugin = 'vim-lsp'
    else
        let s:my_lsp_plugin = 'none'
    endif
    let s:my_lsp_filetypes = ['haskell', 'lhaskell', 'python',
                \ 'typescript', 'javascript', 'rust',
                \ 'c', 'cpp']

    augroup my_lsp
        autocmd FileType * call s:configure_lsp()
    augroup END
endfunction
