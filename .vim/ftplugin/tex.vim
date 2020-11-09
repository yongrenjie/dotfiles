syntax region texZone start='\\begin{cmdline}' end='\\end{cmdline}'
syntax region texZone start='\\begin{script}' end='\\end{script}'
syntax region texMathZoneZ matchgroup=texStatement start="\\ce{" start="\\cf{" matchgroup=texStatement end="}" end="%stopzone\>" contains=@texMathZoneGroup

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
let g:vimtex_fold_enabled=1
let g:vimtex_fold_manual=1
let g:vimtex_syntax_enabled=0 " otherwise it throws an error since I'm not using default syntax file
" Disable imaps (I can't get it to work, and I have a feeling it's because I
" disabled the vimtex syntax file)
let g:vimtex_imaps_enabled=0

" PDF viewer for vimtex in WSL
let s:uname = system("uname")
if s:uname == "Linux\n"
    let g:vimtex_view_general_viewer = "okular"
endif
