nnoremap <buffer><silent> <leader>t :VimtexTocToggle<CR>

function! ToggleEnv() abort " {{{1
    " Modified from vimtex#env#toggle_star. Uses vimtex internals thus liable
    " to breaking! But that's a risk I'm willing to take
    let [l:open, l:close] = vimtex#env#get_surrounding('normal')
    if empty(l:open) | return | endif
    if l:open.name ==# 'equation'
        call vimtex#env#change(l:open, l:close, l:open.starred ? 'align*' : 'align')
    elseif l:open.name ==# 'align'
        call vimtex#env#change(l:open, l:close, l:open.starred ? 'equation*' : 'equation')
    elseif l:open.name ==# 'itemize'
        call vimtex#env#change(l:open, l:close, 'enumerate')
    elseif l:open.name ==# 'enumerate'
        call vimtex#env#change(l:open, l:close, 'itemize')
    endif
endfunction
" }}}1
nnoremap <buffer><silent> <leader>e :call ToggleEnv()<CR>

function! OpenDOIFromLatex(citekey) abort " {{{1
    " Open a web reference from a cite key -- by parsing the bib file and then
    " opening the DOI in a browser.
    " Hacky and relies on vimtex internals -- not recommended for production
    " usage, but this is so useful that I can't pass it up.
    let l:bib_files = vimtex#bib#files()->sort()->uniq()
    if empty(l:bib_files)
        echo 'Bib file not found'
        return
    endif

    let l:entries = []
    for l:bib_file in l:bib_files
        let l:this_file_entries = vimtex#parser#bib#parse(l:bib_file, {})
        call filter(l:this_file_entries, {_, val -> val.key == a:citekey})
        let l:entries += l:this_file_entries
    endfor
    if empty(l:entries)
        echo 'Bib entry with key ' . a:citekey . ' not found'
        return
    endif
    
    if !has_key(l:entries[0], 'doi')
        echo 'Bib entry with key ' . a:citekey . ' was found, but did not have an associated DOI'
        return
    endif

    let l:doi = (l:entries[0]).doi
    silent exe '!open -a Firefox -g ' . shellescape('https://doi.org/' . l:doi)
endfunction
" }}}1
nnoremap <buffer><silent> <leader>o :call OpenDOIFromLatex(expand('<cword>'))<CR>

" Change vimtex ToC highlighting. This may not generally be necessary
" depending on colorscheme but right now I'm using one.vim in light mode and
" the subsections in my thesis are red, which is pretty ugly.
" Check inside autoload/vimtex/options.vim for the default highlighting
highlight link VimtexTocSec2 NONE
" Note: Use 'Comment' for edge or 'NonText' for one-light
highlight link VimtexTocSec2 Comment

" read more characters of the author list, and show the article title as the
" detail
let g:vimtex_complete_bib.auth_len = 150
let g:vimtex_complete_bib.menu_fmt = '@title'

if 0
" Custom text object for LaTeX quotes using vim-textobj-user {{{1
" Disabled for the time being because it doesn't differentiate between single
" and double quotes totally correctly.
call textobj#user#plugin('tex', {
\   'single-quote': {
\     'pattern': ['`', "'"],
\     'select-a': [],
\     'select-i': [],
\   },
\   'double-quote': {
\     'pattern': ['``', "''"],
\     'select-a': [],
\     'select-i': [],
\   },
\ })
call textobj#user#map('tex', {
  \   'single-quote': {
  \     'select-a': '<buffer> aq',
  \     'select-i': '<buffer> iq',
  \   },
  \   'double-quote': {
  \     'select-a': '<buffer> aQ',
  \     'select-i': '<buffer> iQ',
  \   },
  \ })
" }}}1
endif


" Thesis-specific mappings {{{1
" These depend on the value of b:is_thesis, which is set in
" .vim/ftplugin/tex.vim. If you want to control when these are triggered, go
" there and change it.
function! s:after_thesis_mappings() abort
    " For debugging (if necessary)
    if 0 | echomsg 'Hi from after/ftplugin' | endif

    " too much prose
	setlocal spell
    setlocal spelllang=en_gb
    setlocal spellfile=/Users/yongrenjie/dphil/thesis/spellcheck.utf-8.add

    " Don't show subsubsections in TOC
    let g:vimtex_toc_config.fold_level_start = 2
    let g:vimtex_toc_config.tocdepth = 2

    " tex is a bloody pain to write without a mouse IMO
    set mouse=nv
    " disable mouse scrolling -- it's too easy to accidentally do
    " so, just use mouse for pointing and clicking
    map <ScrollWheelUp> <Nop>
    map <S-ScrollWheelUp> <Nop>
    map <ScrollWheelDown> <Nop>
    map <S-ScrollWheelDown> <Nop>

    " Mapping to reset my view
    nnoremap <silent><buffer> <leader>h :only<CR>:e ~/dphil/thesis/thesis.tex<CR>:VimtexTocToggle<CR>

    " Make custom mappings for vimtex TOC
    augroup thesis-after | au!
        " Make CR and Space behave simil)arly (i.e. don't close the ToC when
        " jumping). Normally, Space doesn't close it and CR closes it.
        autocmd User VimtexEventTocCreated nmap <buffer> <CR> <Space>
        " disable some things which are annoying
        autocmd User VimtexEventTocCreated nmap <buffer> <Esc> <Nop>
        autocmd User VimtexEventTocCreated nmap <buffer> <C-O> <Nop>
        autocmd User VimtexEventTocCreated nmap <buffer> <C-I> <Nop>
        " Make = behave like +, avoiding having to press Shift.
        autocmd User VimtexEventTocCreated nmap <buffer> = +
        " Make { and } move between chapters, [ and ] move between section
        " nowait makes these take priority over other mappings beginning with []
        autocmd User VimtexEventTocCreated nmap <buffer><silent><nowait> { ?\v^L0<CR>
        autocmd User VimtexEventTocCreated nmap <buffer><silent><nowait> } /\v^L0<CR>
        autocmd User VimtexEventTocCreated nmap <buffer><silent><nowait> [ ?\v^L[01]<CR>
        autocmd User VimtexEventTocCreated nmap <buffer><silent><nowait> ] /\v^L[01]<CR>
        " make C-^ work in the actual tex file instead of the toc
        autocmd User VimtexEventTocCreated nnoremap <buffer><silent> <C-^> <C-w>w<C-^>

        " set O mark when leaving and use o to get back to it quickly from toc
        " note, unfortunately, that this doesn't work with various
        " combinations of wq/qa/wa/wqa which is an issue with the vim autocmd
        " events, not my code
        function! Set_O_Mark() abort
            if &filetype == 'tex' | mark O | endif
        endfunction
        autocmd QuitPre * call Set_O_Mark()
        autocmd BufWrite * call Set_O_Mark()
        autocmd User VimtexEventTocCreated nnoremap <buffer><silent> o <C-w>w'O
    augroup END

    " Compile and open ToC automatically if it was the first file opened
    if expand('%') =~# 'thesis.tex' && len(getbufinfo()) == 1
        VimtexCompile
        VimtexTocToggle
    endif

    " make fzf mappings search only files of interest
    let s:extensions = ['tex', 'py']
    function! ThesisFiles() abort
        " Search for files with the extensions in ~/dphil/thesis
        " Then sort by last modified time, see sharkdp/fd#640
        let l:fd_command = 'fd' 
                    \ . join(map(s:extensions, {_, val -> ' -e ' . val}), '') 
                    \ . ' --base-directory ~/dphil/thesis .'
                    \ . ' --exec stat -f "%m%t%N" | sort -nr | cut -f2'
        call fzf#run(fzf#vim#with_preview(
                    \ fzf#wrap({'source': l:fd_command, 'sink': 'e'})
                    \ ))
    endfunction
    nnoremap <buffer><silent> <leader>f :call ThesisFiles()<CR>

    " doesn't autoupdate -- mostly equivalent to default :Rg except that file
    " extensions are restricted
    function! ThesisRipgrep() abort
        let l:rg_command = 'rg --line-number --no-heading --color=always --smart-case'
                    \ . join(map(s:extensions, {_, val -> ' -t ' . val}), '') 
                    \ . ' -- ""'
        call fzf#vim#grep(l:rg_command, 1, fzf#vim#with_preview(), 0)
    endfunction
    " this version autoupdates when the query is changed, so it's a bit
    " slower, but it shows column numbers and jumps to the right column when
    " selected. The code is mostly lifted from the fzf.vim readme.
    function! ThesisRipgrepColumn(query)
        let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case'
                    \ . join(map(s:extensions, {_, val -> ' -t ' . val}), '') 
                    \ . ' -- %s'
                    \ . ' || true'
        let initial_command = printf(command_fmt, shellescape(a:query))
        let reload_command = printf(command_fmt, '{q}')
        let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
        echomsg initial_command
        call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), 0)
    endfunction
    nnoremap <buffer><silent> <leader>r :call ThesisRipgrepColumn('')<CR>
endfunction

if exists('b:is_thesis')   " set in .vim/ftplugin/tex.vim
    call s:after_thesis_mappings()
endif
" }}}1


" vim: foldmethod=marker
