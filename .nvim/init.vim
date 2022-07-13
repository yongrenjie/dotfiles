" Plugins. The directory is gitignored.
call plug#begin('~/.nvim/plugged')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-tbone'
Plug 'wellle/targets.vim'
Plug 'machakann/vim-sandwich'
Plug 'rakr/vim-one'
Plug 'itchyny/lightline.vim'
Plug 'SirVer/ultisnips'
Plug 'lervag/vimtex'
Plug 'yongrenjie/abbotsbury.vim'
Plug 'yongrenjie/vim-bruker'
Plug 'itchyny/vim-haskell-indent'
Plug 'yongrenjie/vim-haskellFold'

call plug#end()

" I never asked you to change it
set guicursor=a:blinkon0
set inccommand=

" Load original vim config
set runtimepath^=~/.vim runtimepath+=~/.vim/after
source ~/.vimrc

" Terminal mode
tnoremap <Esc> <C-\><C-n>

" Treesitter setup (Lua) {{{1
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
" }}}1

" LSP setup (Lua) {{{1
lua << EOF
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- formatexpr
  vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

  -- https://www.reddit.com/r/neovim/comments/nytu9c
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, { focusable = false }
  )
end

local on_attach_no_formatexpr = function(client, bufnr)
  on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(0, 'formatexpr', '')
end

-- Servers.
require'lspconfig'.pyright.setup{on_attach = on_attach}
require'lspconfig'.clangd.setup{on_attach = on_attach}
require'lspconfig'.hls.setup{on_attach = on_attach_no_formatexpr}
require'lspconfig'.tsserver.setup{on_attach = on_attach}
EOF
" }}}1

" vim: foldmethod=marker
