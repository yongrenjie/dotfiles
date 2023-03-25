let &formatprg='ocamlformat --impl -'
set textwidth=80
set tabstop=2
set shiftwidth=2

" Defined in ~/.vim/autoload/ocaml.vim
nnoremap <silent> <buffer> <leader>i :<C-U>call ocaml#ToggleImplIntf()<CR>
