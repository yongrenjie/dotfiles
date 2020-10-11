function ExpandDOI()
let doi = expand("<cWORD>")
echo "expanding DOI " .. doi .. "..."
python3<<EOF
import vim
from peeplatex.peepcls import DOI
# get the citation
doi = vim.eval('expand("<cWORD>")')
try:
    citation = DOI(doi).to_citation(type="bib")
    citation = citation.replace("'", "''")
except Exception as e:
    citation = "error"
vim.command("let citation='{}'".format(citation))
EOF
if citation != "error"
    let lineno = line(".")
    " twiddle with empty lines before citation
    if !empty(trim(getline(line(".") - 1)))
        let x = append(line(".") - 1, "")
        let lineno += 1
    endif
    " replace the line with the citation
    put =citation | redraw
    " twiddle with empty lines after citation
    if !empty(trim(getline(line(".") + 1)))
        let x = append(line("."), "")
    endif
    execute lineno .. " delete _"
else
    redraw | echohl ErrorMsg | echo "invalid DOI " .. doi | echohl None
endif
endfunction

nnoremap <leader>e :call ExpandDOI() <CR>
