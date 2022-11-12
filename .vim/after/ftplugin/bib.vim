let g:abbot_cite_style = "bib"
let g:abbot_replace_text = "linespace"

autocmd FocusLost * wall


function! OpenUrl() abort
    " find the opening of the entry
    let opening_line = search('\v^\s*\@', 'bcnW')
    let closing_line = search('\v^\s*\@', 'nW')
    if opening_line >= closing_line
        echomsg 'bib entry start and end not found'
        return
    endif

    for lineno in range(opening_line, closing_line - 1)
        let match_result = matchlist(getline(lineno), '\v\s*doi\s*\=\s*\{(.+)\}')
        if len(match_result) < 2 | continue | endif
        " validate, using same rule as in abbotsbury.vim
        let doi = match_result[1]
        if doi !~? '\v^10\.\d{4,9}/\S+$' | continue | endif

        " if we reach here, it found a valid doi
        echo 'opening doi: ' . doi
        let escaped_doi = shellescape('https://doi.org/' . doi)
        let command = "!open -g -a 'Firefox' " . escaped_doi . ""
        silent exe command
        redraw!
        return
    endfor

    echomsg 'DOI not found'
    return
endfunction
nnoremap <buffer><silent> <leader>o :call OpenUrl()<CR>
