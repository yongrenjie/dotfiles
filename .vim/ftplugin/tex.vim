set fillchars=fold:\ 
" Read in LaTeX template
nnoremap <buffer><silent> rtrt gg:<C-U>r ~/dotfiles/latex_template.tex<CR>ggdd

" Word count function (relies on pdftotext being installed)
" ---------------------------------------------------------
function! WC()
    let pdfname = expand("%:p:r") .. '.pdf'
    let command = 'pdftotext ' .. pdfname .. ' - | grep -v "^\s*$" | wc'
    let result = system(command)
    echo trim(result)
endfunction
command WC :call WC()

" Vimtex settings
" ---------------
" Remove automatic indentation for certain LaTeX environments
" cmdline and script are user-defined envs for the SBM comp chem tutorial...
let g:vimtex_indent_lists = ['itemize', 'description', 'enumerate', 'thebibliography', 'minted']

" Enable folding
let g:vimtex_fold_enabled = 1
" Disable preamble and refsection folding
let g:vimtex_fold_types = { 
            \ 'preamble' : { 'enabled' : 0 },
            \ 'envs': { 
                \ 'blacklist': ['refsection'] 
                \ }
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
            \ "contains only floats",
            \ ]

" Add LaTeX quotes to vim-sandwich.
" This won't always work (e.g. if quotes are around some text with
" apostrophes), but useful for simple scenarios.
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
            \ {'buns': ['`', "'"], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ["`'"]},
            \ {'buns': ['``', "''"], 'filetype': ['tex', 'plaintex'], 'nesting': 0, 'input': ['`"']},
            \ ]

" vim: foldmethod=marker
