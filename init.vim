set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
packadd firenvim
let g:firenvim_config = {'globalSettings': {}, 'localSettings': {}}
let fc = g:firenvim_config['localSettings']
let fc['.*'] = { 'takeover': 'never' }
source ~/.vimrc
set background=light
set nohlsearch

function! s:IsFirenvimActive(event) abort
    if !exists('*nvim_get_chan_info')
        return 0
    endif
    let l:ui = nvim_get_chan_info(a:event.chan)
    return has_key(l:ui, 'client') && has_key(l:ui.client, 'name') &&
                \ l:ui.client.name =~? 'Firenvim'
endfunction

" Autocommands to be run when editing in firenvim.
" We only really want to use this for JupyterLab and MAYBE Stack Exchange.
function! OnUIEnter(event) abort
    if s:IsFirenvimActive(a:event)
        set termguicolors
        set laststatus=0
        set guifont=SF\ Mono:h10
        colorscheme PaperColor
        " Cmd-1, Cmd-2, Cmd-3 to set filetype
        nnoremap <silent> <D-1> :set filetype=python<CR>
        inoremap <silent> <D-1> <C-O>:set filetype=python<CR>
        nnoremap <silent> <D-2> :set filetype=markdown<CR>
        inoremap <silent> <D-2> <C-O>:set filetype=markdown<CR>
        nnoremap <silent> <D-3> :set filetype=text<CR>
        inoremap <silent> <D-3> <C-O>:set filetype=text<CR>
    endif
endfunction
autocmd UIEnter * call OnUIEnter(deepcopy(v:event))

function! InitialiseJLab()
    set filetype=python  " most likely. Can always set with Cmd-n.
    " BTW, filetype can't be set in UIEnter, I think there's some stuff that
    " goes on between then and BufEnter which overrides any file type set in
    " UIEnter.
    " Disable Enter key.
    nnoremap <CR> <NOP>
    " If we press Shift-Enter we presumably want to run the thing.
    nnoremap <S-CR> :wq<CR>
    " Disable textwidth in JupyterLab
    set textwidth=0
endfunction
autocmd BufEnter localhost* call InitialiseJLab()

function! UpdateLines()
    " Automatically extend the textbox if we have no more space
    if line('$') >= &lines - 2
        let &lines = line('$') + 2
    endif
endfunction
function! JLabUpdateLines()
    " inoremap <silent> <CR> <C-O>:call UpdateLines()<CR><CR>
    nnoremap <silent> o :call UpdateLines()<CR>o
    nnoremap <silent> O :call UpdateLines()<CR>O
    " This one is slow, but general
    " autocmd TextChanged * call UpdateLines()
endfunction
autocmd BufWrite localhost* call JLabUpdateLines()
