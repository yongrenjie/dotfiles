" Note: Plugins are loaded in ~/.vimrc.
" This file only contains nvim-specific configuration.

" Revert some new nvim defaults
set guicursor=a:blinkon0
if exists('g:vscode')
    set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
                \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
                \,sm:block-blinkwait175-blinkoff150-blinkon175
endif
set inccommand=

" Load original vim config
set runtimepath^=~/.vim runtimepath+=~/.vim/after
source ~/.vimrc

" Terminal mode
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

" The rest is plugin setup and configuration.
if exists('g:vscode') | finish | endif

if exists('g:loaded_copilot')
    imap <C-9> <Cmd>:call copilot#Next()<CR>
    imap <C-0> <Cmd>:call copilot#Previous()<CR>
endif

" Treesitter {{{1
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
        "r",
        "svelte",
        "rust",
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
" }}}1
" LSP {{{1
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
  vim.keymap.set('n', '<space>x', vim.lsp.buf.rename, bufopts)
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

-- Servers.
-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
require'lspconfig'.pyright.setup{on_attach = on_attach}
require'lspconfig'.clangd.setup{on_attach = on_attach}
require'lspconfig'.hls.setup{on_attach = on_attach}
require'lspconfig'.tsserver.setup{on_attach = on_attach}
require'lspconfig'.ocamllsp.setup{on_attach = on_attach}
require'lspconfig'.r_language_server.setup{on_attach = on_attach}
require'lspconfig'.svelte.setup{on_attach = on_attach}
require'lspconfig'.svelte.setup{on_attach = on_attach}
require'lspconfig'.eslint.setup{on_attach = on_attach}
require'lspconfig'.rust_analyzer.setup{on_attach = on_attach}
EOF
" }}}1
" Quarto {{{1
lua << EOF
vim.g['pandoc#syntax#conceal#use'] = false
require'quarto'.setup{
  lspFeatures = {
    enabled = true,
  }
}
EOF
command! QP QuartoPreview
command! QCP QuartoClosePreview
function! s:QRP() abort
    QuartoClosePreview
    QuartoPreview
endfunction
command! QRP call s:QRP()
" }}}1
" Trouble {{{1
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
" }}}1

lua << EOF
require "lsp_signature".setup({
    hint_prefix = "🐧 ",
    trigger_on_newline = false,
})
EOF

" vim: foldmethod=marker
