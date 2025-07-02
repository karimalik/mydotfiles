-- init.lua - Configuration principale Neovim avec Terminal et Debug
-- %LOCALAPPDATA%\nvim\init.lua

-- Options de base
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = 'menuone,noselect'
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Auto-save configuration
vim.opt.autowrite = true
vim.opt.autowriteall = true

-- Auto-save sur focus lost et buffer change
vim.api.nvim_create_autocmd({"FocusLost", "BufLeave", "BufWinLeave", "InsertLeave"}, {
  pattern = "*",
  command = "silent! wa"
})

-- Commande personnalisée pour vider le log de Mason
vim.api.nvim_create_user_command("MasonClearLog", function()
  local log_path = vim.fn.stdpath("data") .. "/mason/log/mason.log"
  local f = io.open(log_path, "w")
  if f then
    f:write("") 
    f:close()
    print("✅ Log Mason vidé")
  else
    print("❌ Impossible d'accéder au fichier de log Mason.")
  end
end, {})

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Installation automatique de packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Plugins
require('packer').startup(function(use)
  -- Gestionnaire de plugins
  use 'wbthomason/packer.nvim'

  -- Thème
  use 'folke/tokyonight.nvim'

  -- Explorateur de fichiers
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
  }

  -- Barre de statut
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- LSP Configuration
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  }

  -- Treesitter pour la coloration syntaxique
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Git integration
  use 'lewis6991/gitsigns.nvim'

  -- Auto pairs
  use 'windwp/nvim-autopairs'

  -- Comment toggle
  use 'numToStr/Comment.nvim'

  -- Indent guides
  use 'lukas-reineke/indent-blankline.nvim'

  -- Buffer line
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

  -- Which-key pour les raccourcis
  use 'folke/which-key.nvim'

  -- Auto-save
  use 'Pocco81/auto-save.nvim'

  -- Laravel blade support
  use 'jwalton512/vim-blade'

  -- PHP support
  use 'StanAngeloff/php.vim'

  -- Ruby support  
  use 'vim-ruby/vim-ruby'

  -- Go support
  use 'fatih/vim-go'

  -- ===============================================
  -- PLUGINS POUR TERMINAL ET DEBUG
  -- ===============================================
  
  -- Terminal amélioré
  use {
    'akinsho/toggleterm.nvim',
    tag = '*',
    config = function()
      require("toggleterm").setup()
    end
  }
  
  -- Debug Adapter Protocol
  use 'mfussenegger/nvim-dap'
  use 'nvim-neotest/nvim-nio'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'nvim-telescope/telescope-dap.nvim'
  
  -- Debug pour différents langages
  use 'leoluz/nvim-dap-go'          -- Go debugging
  use 'mfussenegger/nvim-dap-python' -- Python debugging
  
  -- Gestion des erreurs et diagnostics
  use {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  }
  
  -- Git UI dans le terminal
  use 'kdheepak/lazygit.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Configuration des plugins 
require('plugin-configs')

-- Configuration pour terminal et debug
require('terminal-debug-config')

-- Keymaps existants
require('keymaps')

-- Thème
vim.cmd[[colorscheme tokyonight-night]]

