function! DetectBruker()
    if search('\#include <[A-Za-z]\+\.incl>')
        setfiletype bruker
    endif
endfunction

augroup bruker_ftdetect
    au BufRead,BufNewFile * call DetectBruker()
augroup END
