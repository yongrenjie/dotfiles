set fillchars=fold:\ 
" Read in LaTeX template
nnoremap <buffer><silent> rtrt gg:<C-U>r ~/dotfiles/latex_template.tex<CR>ggdd

" iQ, iq, aQ, aq text objects {{{1
function! s:QuotesTextObj(textobj_type, quote_type) abort
    " textobj_type: 'i' for inner, 'a' for around
    " quote_type: 'q' for single quote (iq/aq), 'Q' for double quotes (iQ/aQ)

    " String comparisons must use ==# to avoid issues with 'ignorecase'!
    let l:start_quote = (a:quote_type ==# 'Q') ? '``' : '\(^\|[^`]\)\zs`\ze\($\|[^`]\)'
    let l:end_quote = (a:quote_type ==# 'Q') ? "''" : '\(^\|[^'']\)\zs''\ze\($\|[^'']\)'
    let l:quote_length = (a:quote_type ==# 'Q') ? 2 : 1

    " First, assume that we're within quotes.
    let l:cursor = getpos('.')
    let l:start_pos = searchpos(l:start_quote, 'bcnW')
    if l:start_pos != [0, 0]
        call setpos('.', [l:cursor[0], l:start_pos[0], l:start_pos[1], 0])
        let l:end_pos = searchpos(l:end_quote, 'cnW')
        " Exit if there are no ending quotes
        if l:end_pos == [0, 0] | call setpos('.', l:cursor) | return | endif
        " If it's an empty pair of quotes, place the cursor between the quotes and exit
        if l:start_pos[0] == l:end_pos[0] && l:start_pos[1] + l:quote_length >= l:end_pos[1]
            call setpos('.', [l:cursor[0], l:start_pos[0], l:start_pos[1] + l:quote_length, 0])
            return
        endif
    endif

    " If we aren't, then try to do intelligent searches
    if l:start_pos == [0, 0] || l:end_pos[0] < l:cursor[1] ||
                \ (l:end_pos[0] == l:cursor[1] && l:end_pos[1] + l:quote_length <= l:cursor[2])
        " Reset cursor
        call setpos('.', l:cursor)
        " Search first in the current line
        let l:start_pos = searchpos(l:start_quote, 'bcnW', line('.'))
        " If couldn't find, try to 'jump ahead'
        if l:start_pos == [0, 0]
            let l:start_pos = searchpos(l:start_quote, 'cnW')
        endif
        " If still couldn't find, try to search in previous lines
        if l:start_pos == [0, 0]
            let l:start_pos = searchpos(l:start_quote, 'bcnW')
        endif
    endif
    " If still couldn't find opening quotes, exit
    if l:start_pos == [0, 0] | call setpos('.', l:cursor) | return | endif

    " Using our knowledge of the starting position, search for the ending
    call setpos('.', [l:cursor[0], l:start_pos[0], l:start_pos[1], 0])
    let l:end_pos = searchpos(l:end_quote, 'cnW')
    if l:end_pos == [0, 0] | call setpos('.', l:cursor) | return | endif

    " Adjust positions according to 'i'/'a' usage
    let l:start_pos = [l:start_pos[0],
                \ l:start_pos[1] + (a:textobj_type == 'i' ? l:quote_length : 0)]
    let l:end_pos = [l:end_pos[0],
                \ l:end_pos[1] + (a:textobj_type == 'i' ? -1 : l:quote_length - 1)]
    " Adjust positions if they overflow/underflow across lines
    if col([l:start_pos[0], '$']) - 1 < l:start_pos[1]
        let l:start_pos = [l:start_pos[0] + 1, 1]
    endif
    if l:end_pos[1] < 1
        let l:end_pos = [l:end_pos[0] - 1, col([l:end_pos[0] - 1, '$']) - 1]
    endif

    " Set marks and enter visual mode
    call setpos("'<", [l:cursor[0], l:start_pos[0], l:start_pos[1], 0])
    call setpos("'>", [l:cursor[0], l:end_pos[0], l:end_pos[1], 0])
    normal! `<v`>
endfunction
vnoremap <buffer><silent> iQ :<C-U>call <SID>QuotesTextObj('i', 'Q')<CR>
vnoremap <buffer><silent> iq :<C-U>call <SID>QuotesTextObj('i', 'q')<CR>
vnoremap <buffer><silent> aQ :<C-U>call <SID>QuotesTextObj('a', 'Q')<CR>
vnoremap <buffer><silent> aq :<C-U>call <SID>QuotesTextObj('a', 'q')<CR>
omap <buffer><silent> iQ :normal viQ<CR>
omap <buffer><silent> iq :normal viq<CR>
omap <buffer><silent> aQ :normal vaQ<CR>
omap <buffer><silent> aq :normal vaq<CR>
" }}}1

" Word count function (relies on pdftotext being installed) {{{1
function! WC()
    let pdfname = expand("%:p:r") .. '.pdf'
    let command = 'pdftotext ' .. pdfname .. ' - | grep -v "^\s*$" | wc'
    let result = system(command)
    echo trim(result)
endfunction
command WC :call WC()
" }}}1

" General VimTeX settings (see also after/ftplugin/tex.vim) {{{1
"
" Remove automatic indentation for certain LaTeX environments
" cmdline and script are user-defined envs for the SBM comp chem tutorial...
let g:vimtex_indent_lists = ['itemize', 'description', 'enumerate', 'thebibliography', 'minted']
let g:vimtex_indent_ignored_envs = ['document', 'appendices', 'frame']

" Enable folding
let g:vimtex_fold_enabled = 1
" Disable preamble and refsection folding
let g:vimtex_fold_types = { 
            \ 'preamble' : { 'enabled' : 0 },
            \ 'envs': { 
                \ 'blacklist': ['refsection'] 
                \ },
            \ }
" Disable batteries-included autocomplete (let VimCompletesMe handle it)
let g:vimtex_include_search_enabled = 0
" Use vim to parse bib files (works with sets... bibtex doesn't)
let g:vimtex_parser_bib_backend = 'vim'
" Single-shot compilation using \m (mimics make for rst and run for python)
nmap <localleader>m <plug>(vimtex-compile-ss)

" Enable forward searching in Skim for MacOS
if system("uname") == "Darwin\n"
    let g:vimtex_view_method = "skim"
endif

" PDF viewer for vimtex in WSL
if system("uname") == "Linux\n"
    let g:vimtex_view_general_viewer = "okular"
endif

" Silence useless hyperref warning
let g:vimtex_quickfix_ignore_filters = [
            \ "hyperref Warning: Draft mode on",
            \ "microtype Warning: `draft' option active.",
            \ "contains only floats",
            \ "Font shape declaration has incorrect series value",
            \ "LaTeX hooks Warning",
            \ ]
" }}}1

" More recipes for vim-sandwich {{{1
let b:sandwich_recipes = deepcopy(g:sandwich#default_recipes)
let b:sandwich_recipes += [
            \ {'buns': ['`', "'"], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ["q"]},
            \ {'buns': ['``', "''"], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ['Q']},
            \ {'buns': ['$', '$'], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ['7']},
            \ {'buns': ['\(', '\)'], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ['8']},
            \ {'buns': ['$$', '$$'], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ['9']},
            \ {'buns': ['\[', '\]'], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ['0']},
            \ {'buns': ['\textbf{', '}'], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ['bb']},
            \ {'buns': ['\textit{', '}'], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ['ii']},
            \ {'buns': ['\mathrm{', '}'], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ['rr']},
            \ {'buns': ['\texttt{', '}'], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ['tt']},
            \ ]
" }}}1

" THESIS-SPECIFIC SETTINGS
" Set $NO_THESIS to any nonempty value to disable
" ... {{{1
function! s:thesis_mappings() abort
    if 0 | echomsg 'Hi from ftplugin' | endif
    " Make ToC wider...
    let vimtex_toc_width = &columns >= 155 ? 55 : 35
    " ...but streamline its contents
    let g:vimtex_toc_config = {
                \ 'layers': ['content'],
                \ 'split_width': vimtex_toc_width,
                \ 'show_help': 0,
                \ 'indent_levels': 1,
                \ }
    " Overwrite folding settings - most folding is not needed because I have
    " separated sections into their own files
    let g:vimtex_fold_types = { 
                \ 'preamble' : { 'enabled' : 0 },
                \ 'items' : { 'enabled' : 0 },
                \ 'envs': { 
                    \ 'whitelist': ['figure', 'table'] 
                    \ },
                \ 'env_options' : { 'enabled' : 1 },
                \ 'markers' : { 'enabled' : 1 },
                \ 'sections' : { 'enabled' : 0 },
                \ 'parts' : { 'enabled' : 0 },
                \ 'cmd_single' : { 'enabled' : 0 },
                \ 'cmd_single_opt' : { 'enabled' : 0 },
                \ 'cmd_multi' : { 'enabled' : 0 },
                \ 'cmd_addplot' : { 'enabled' : 0 },
                \ }
endfunction

if expand('%:p') =~# 'dphil/thesis' && empty($NO_THESIS)
    let b:is_thesis = 1
    call s:thesis_mappings()
endif
" I tried playing around with autocmds, but because of the order in which
" these files are sourced and autocmd events fire, it's not easy to have a
" robust solution based on autocmds. This crude check against the buffer path
" is the best I could do.
"
" }}}1

" vim: foldmethod=marker
