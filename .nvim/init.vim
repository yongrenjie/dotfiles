" Plugins. The directory is gitignored.
call plug#begin('~/.nvim/plugged')
if !exists('g:vscode')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'neovim/nvim-lspconfig'
    Plug 'folke/trouble.nvim'
    Plug 'folke/lsp-colors.nvim'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'quarto-dev/quarto-vim'
    Plug 'quarto-dev/quarto-nvim'
    Plug 'jmbuhr/otter.nvim'
endif

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-tbone'
Plug 'wellle/targets.vim'
Plug 'machakann/vim-sandwich'
Plug 'sainnhe/edge'
Plug 'NLKNguyen/papercolor-theme'
Plug 'itchyny/lightline.vim'
Plug 'SirVer/ultisnips'
Plug 'lervag/vimtex'
Plug 'itchyny/vim-haskell-indent'
Plug 'tmhedberg/SimpylFold'
Plug 'konfekt/FastFold'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'kana/vim-textobj-user'
Plug 'junegunn/vim-easy-align'
Plug 'vim-pandoc/vim-pandoc-syntax'

Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-SpellCheck'

Plug '~/.vim/pack/plugins/start/abbotsbury.vim'
Plug '~/.vim/pack/plugins/start/vim-bruker'
Plug '~/.vim/pack/plugins/start/vim-haskellFold'
Plug '~/.vim/pack/plugins/opt/vim-one'
" Not working with nvim
" Plug '~/.vim/pack/plugins/start/vim-search-pulse'
call plug#end()

" I never asked you to change it
set guicursor=a:blinkon0
set inccommand=

" Load original vim config
set runtimepath^=~/.vim runtimepath+=~/.vim/after
source ~/.vimrc

" Terminal mode
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

" Treesitter setup (Lua) {{{1
if !exists('g:vscode')
lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "help",
        "python",
        "haskell",
        "typescript",
        "javascript",
        "html",
        "css",
        "c",
        "cpp",
        "vim",
        "lua",
        "ocaml",
        "markdown",
        "r"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
        disable = {"python"},
    },
}
EOF
endif
" }}}1

" LSP setup (Lua) {{{1
if !exists('g:vscode')
lua << EOF
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>m', vim.diagnostic.open_float, opts)
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
  vim.keymap.set('n', 'K', function()
    if vim.api.nvim_win_get_config(0).relative ~= '' then
      -- I don't know why this doesn't get called
      vim.api.nvim_win_close(0)
    else
      vim.lsp.buf.hover()
    end
  end, bufopts)
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
  vim.keymap.set('n', '<space>F', function()
    vim.lsp.buf.format({async = true})
  end, bufopts)

  -- Make it impossible to enter LSP popup. https://www.reddit.com/r/neovim/comments/nytu9c
  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  --   vim.lsp.handlers.hover, { focusable = false }
  -- )
end

local on_attach_no_formatexpr = function(client, bufnr)
  on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(0, 'formatexpr', '')
end

-- Servers.
-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
require'lspconfig'.pyright.setup{on_attach = on_attach}
require'lspconfig'.clangd.setup{on_attach = on_attach}
require'lspconfig'.hls.setup{on_attach = on_attach_no_formatexpr}
require'lspconfig'.tsserver.setup{on_attach = on_attach}
require'lspconfig'.ocamllsp.setup{on_attach = on_attach}
require'lspconfig'.r_language_server.setup{on_attach = on_attach}
EOF
endif
" }}}1

if !exists('g:vscode')
lua << EOF
vim.g['pandoc#syntax#conceal#use'] = false
require'quarto'.setup{
  lspFeatures = {
    enabled = true,
  }
}
EOF
command QP QuartoPreview
endif

if !exists('g:vscode')
nnoremap <leader>d <Cmd>TroubleToggle<CR>
lua << EOF
require("trouble").setup {
    padding = false,
    icons = false,
    fold_open = "v", -- icon used for open folds
    fold_closed = ">", -- icon used for closed folds
    indent_lines = false, -- add an indent guide below the fold icons
    signs = {
        -- icons / text used for a diagnostic
        error = "error",
        warning = "warn",
        hint = "hint",
        information = "info"
        },
    use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
    }
EOF
endif

" vim: foldmethod=marker
