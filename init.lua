local o = vim.opt
local g = vim.g

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Keybinds
local map = vim.api.nvim_set_keymap
local opts = { silent = true, noremap = true }

local builtin = require("telescope.builtin")

map("n", "<C-n>", ":NvimTreeFocus<CR>", {})

vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<C-f>", builtin.live_grep, {})
vim.keymap.set("n", "<C-h>", builtin.buffers, {})

require('lspconfig').rust_analyzer.setup {}
require('lspconfig').rnix.setup {}
require('lspconfig').zk.setup {}

require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

require("nvim-tree").setup()

-- Format
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

require('onenord').setup()

g.mapleader = ' '

-- Performance
o.lazyredraw = true;
o.shell = "zsh"
o.shadafile = "NONE"

-- Colors
o.termguicolors = true

-- Undo files
o.undofile = true

-- Indentation
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4
o.shiftround = true
o.expandtab = true
o.scrolloff = 3

-- Set clipboard to use system clipboard
o.clipboard = "unnamedplus"

-- Use mouse
o.mouse = "a"

-- Nicer UI settings
o.cursorline = true
o.number = true

-- Get rid of annoying viminfo file
o.viminfo = ""
o.viminfofile = "NONE"

-- Miscellaneous quality of life
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
