syntax region texZone start='\\begin{cmdline}' end='\\end{cmdline}'
syntax region texZone start='\\begin{script}' end='\\end{script}'
syntax region texMathZoneZ matchgroup=texStatement start="\\ce{" start="\\cf{" matchgroup=texStatement end="}" end="%stopzone\>" contains=@texMathZoneGroup

command Pdflatex :! pdflatex % 

" Set TeX flavour. This is needed for tex.snippets to work.
" Without this, :set ft? will give 'plaintex'; with it, :set ft? will give
" 'tex'. See :h tex_flavor for more info
let g:tex_flavor='latex'

" ---------------
" Vimtex settings

" Remove automatic indentation for certain LaTeX environments
" cmdline and script are user-defined envs for the SBM comp chem tutorial...
let g:vimtex_indent_lists=['itemize', 'description', 'enumerate', 'thebibliography']
let g:vimtex_fold_enabled=1
let g:vimtex_fold_manual=1
let g:vimtex_syntax_enabled=0 " otherwise it throws an error since I'm not using default syntax file
" PDF viewer for vimtex in WSL
let s:uname = system("uname")
if s:uname == "Linux\n"
    let g:vimtex_view_general_viewer = "okular"
endif
