nnoremap <buffer> j gj
nnoremap <buffer> k gk
vnoremap <buffer> j gj
vnoremap <buffer> k gk

syntax region texZone start='\\begin{cmdline}' end='\\end{cmdline}'
syntax region texZone start='\\begin{script}' end='\\end{script}'
syntax region texMathZoneZ matchgroup=texStatement start="\\ce{" start="\\cf{" matchgroup=texStatement end="}" end="%stopzone\>" contains=@texMathZoneGroup

command Pdflatex :! pdflatex % 
