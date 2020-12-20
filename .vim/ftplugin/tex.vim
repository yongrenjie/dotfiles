command Pdflatex :! pdflatex % 

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
let g:vimtex_indent_lists=['itemize', 'description', 'enumerate', 'thebibliography', 'minted']

" Enable folding
let g:vimtex_fold_enabled=1
let g:vimtex_fold_manual=1  " use FastFold
" Disable preamble folding (I nowadays supply manual folds)
let  g:vimtex_fold_types = { 'preamble' : {'enabled' : 0} }

let g:vimtex_syntax_enabled=1
" Disable imaps
let g:vimtex_imaps_enabled=0
" Single-shot compilation using \m (mimics make for rst and run for python)
nmap <localleader>m <plug>(vimtex-compile-ss)

" PDF viewer for vimtex in WSL
if system("uname") == "Linux\n"
    let g:vimtex_view_general_viewer = "okular"
endif

" Silence useless hyperref warning
let g:vimtex_quickfix_ignore_filters = [
            \ "hyperref Warning: Draft mode on",
            \ "contains only floats",
            \ ]
