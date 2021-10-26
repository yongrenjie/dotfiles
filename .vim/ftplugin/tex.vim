set fillchars=fold:\ 
" Read in LaTeX template
nnoremap <buffer><silent> rtrt gg:<C-U>r ~/dotfiles/latex_template.tex<CR>ggdd

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
            \ ]

" Add LaTeX quotes to vim-sandwich.
" This won't always work (e.g. if quotes are around some text with
" apostrophes), but useful for simple scenarios.
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
            \ ]
" }}}1

" Thesis-specific settings {{{1
function! s:thesis_mappings() abort
    if 0 | echomsg 'Hi from ftplugin' | endif
    " Make ToC wider...
    let vimtex_toc_width = &columns >= 155 ? 55 : 40
    " ...but streamline its contents
    let g:vimtex_toc_config = {
                \ 'layers': ['content'],
                \ 'split_width': vimtex_toc_width,
                \ 'show_help': 0,
                \ 'indent_levels': 1,
                \ }
endfunction

if expand('%:p') =~# 'dphil/thesis'
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
