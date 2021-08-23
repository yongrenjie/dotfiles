set nocompatible
filetype plugin on
" let &runtimepath = '~/.vim/pack/plugins/start/vimtex,' . &runtimepath
" let &runtimepath = '~/.vim/pack/plugins/start/vim-commentary,' . &runtimepath
" let &runtimepath = '~/.vim/pack/plugins/start/targets.vim,' . &runtimepath

if !has('nvim')
    " packadd vimtex
    packadd vim-sandwich
    " packadd targets.vim
endif
