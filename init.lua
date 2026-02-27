--
-- General
--
vim.bo.fileencoding = 'utf-8'
vim.o.backup = false
vim.bo.swapfile = false
vim.o.autoread = true
vim.o.showcmd = true
vim.cmd 'filetype plugin indent on'
vim.o.updatetime = 300
vim.wo.signcolumn = "yes"
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.laststatus = 2
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.o.showmode = false
vim.wo.cursorline = true
vim.bo.syntax = 'ON'
vim.o.hlsearch = true
vim.o.incsearch = true
vim.bo.smartindent = true
vim.bo.autoindent = true
-- if filetype is tsx, tsxreact, js, jsreact, then use 2 spaces
vim.bo.tabstop = 8
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = false
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    vim.bo.tabstop     = 2      -- <Tab> の見かけ幅
    vim.bo.shiftwidth  = 2      -- >> や auto‑indent の幅
    vim.bo.softtabstop = 2      -- <BS> 時の減る幅
    vim.bo.expandtab   = true   -- 実際のファイルにも半角 2 個のスペース
  end,
})
vim.o.mousemoveevent = true

-- gui
vim.o.guifont = 'PlemolJP Console NF:h13'
if vim.g.neovide then
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_refresh_rate_idle = 5
end

-- clipboard
if vim.fn.has('wsl') == 1 then
    vim.g.clipboard = {
        name = 'win32yank_wsl',
        copy = {
            ['+'] = 'win32yank.exe -i --crlf',
            ['*'] = 'win32yank.exe -i --crlf',
        },
        paste = {
            ['+'] = 'win32yank.exe -o --lf',
            ['*'] = 'win32yank.exe -o --lf',
        },
        cache_enabled = true,
    }
end

-- terminal
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    vim.o.shell = "pwsh.exe"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
	vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
	vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
elseif vim.fn.has('linux') then
    vim.o.shell = "fish"
end

-- python, ruby, perl
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 or vim.fn.has('wsl') then
    vim.g.python3_host_prog = 'python3'
elseif vim.fn.has('linux') then
    vim.g.python3_host_prog = "/usr/bin/python3.11"
end
vim.cmd 'let g:loaded_perl_provider = 0'
vim.cmd 'let g:loaded_ruby_provider = 0'

--
-- plugins
--
-- LSP config cited from https://namileriblog.com/mac/lazy_nvim_lsp/
--

-- Lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
local plugins = {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
    	'nvim-lualine/lualine.nvim',
    	dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
          -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },
    'tpope/vim-commentary',
    'ryanoasis/vim-devicons',
    'lewis6991/gitsigns.nvim',
    'github/copilot.vim',
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
	-- lsp icons like vscode
	{
	    "onsails/lspkind.nvim",
	    event = "InsertEnter",
	},
}

if (vim.fn.has('wsl') == 1) then
    table.insert(plugins, {
    })
end
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    table.insert(plugins, {
    })
end

require('lazy').setup(plugins)

-- colorscheme
require('tokyonight').setup {}
vim.cmd[[colorscheme tokyonight-night]]
require('neo-tree').setup {
    filesystem = {
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
        }
    },
}

require('bufferline').setup{
    options = {
        separator_style = "slant",
        hover = {
            enabled = true,
            delay = 0,
            reveal = { 'close' },
        },
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left",
                separator = true,
            }
        },
    },
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    globalstatus = true,
  }
}

require('gitsigns').setup()

--
-- Key Maps
--
-- vim.api.nvim_set_keymap('i', '<CR>', '<C-y>', { noremap = true })
vim.api.nvim_set_keymap('n', ']b', ':bnext<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '[b', ':bprev<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', 'M-v', '<C-v>', { noremap = true })
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>c', '"+y', { silent=true, noremap=true }) 
vim.api.nvim_set_keymap('n', '<leader>v', '"+p', { silent=true, noremap=true }) 
vim.api.nvim_set_keymap('v', '<leader>v', '"+p', { silent=true, noremap=true }) 
vim.api.nvim_set_keymap('n', '<space>e', ':Neotree<CR>', { silent=true, noremap=true })

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

local function ex_opts(desc, buffer)
    local final_opts = vim.tbl_extend("force", opts, {})
    if desc then
        final_opts.desc = desc
    end
    if buffer then
        final_opts.buffer = buffer
    end
    return final_opts
end
