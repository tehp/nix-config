local o = vim.opt
local g = vim.g
local map = vim.api.nvim_set_keymap
local opts = { silent = true, noremap = true }

require('onenord').setup()
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.mapleader = ' '
o.lazyredraw = true;
o.shell = "zsh"
o.shadafile = "NONE"
o.termguicolors = true
o.undofile = true
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4
o.shiftround = true
o.expandtab = true
o.scrolloff = 3
o.clipboard = "unnamedplus"
o.mouse = "a"
o.cursorline = true
o.number = true
o.viminfo = ""
o.viminfofile = "NONE"
o.ignorecase = true
o.ttimeoutlen = 5
o.hidden = true
o.shortmess = "atI"
o.wrap = false
o.backup = false
o.writebackup = false
o.errorbells = false
o.swapfile = false
o.showmode = false
o.laststatus = 3
o.pumheight = 6
o.splitright = true
o.splitbelow = true
o.completeopt = "menuone,noselect"
o.smartcase = true

local builtin = require("telescope.builtin")

map("n", "<C-n>", ":NvimTreeFocus<CR>", {})

vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<C-f>", builtin.live_grep, {})
vim.keymap.set("n", "<C-h>", builtin.buffers, {})

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require("nvim-tree").setup()

-- cmp default setup
local cmp = require 'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').rust_analyzer.setup { capabilities = capabilities }
require('lspconfig').rnix.setup { capabilities = capabilities }
require('lspconfig').zk.setup { capabilities = capabilities }
require('lspconfig').lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- Format
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
