" https://otavio.dev/2018/09/30/migrating-from-vim-to-neovim/

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" I never asked you to change it
set guicursor=

" Treesitter
packadd nvim-treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "python", "haskell", "typescript", "javascript", "html", "css", "c", "cpp"
    },
    highlight = {
        enable = true
    }
}
EOF
