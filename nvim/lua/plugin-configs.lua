-- lua/plugin-configs.lua
-- Configuration nvim-tree (Explorateur de fichiers)
vim = vim or require('vim')

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
        },
    },
    filters = {
        dotfiles = false,
    },
    git = {
        enable = true,
        ignore = false,
    },
    actions = {
        open_file = {
            quit_on_open = false,
        },
    },
})

-- Configuration Lualine (Barre de statut)
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
}

-- Configuration Telescope
require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            ".git/",
            "vendor/",
            "storage/",
            "bootstrap/cache/"
        }
    }
}

-- Configuration LSP
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- Configuration Mason pour installer les serveurs LSP
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'intelephense',               -- PHP
        --'solargraph',                 -- Ruby
        'gopls',                      -- Go
        'ts_ls',                      -- TypeScript/JavaScript
        'tailwindcss',                -- Tailwind CSS
        'html',                       -- HTML
        'cssls',                      -- CSS
        'jsonls',                     -- JSON
    },
    handlers = {
        lsp_zero.default_setup,

        -- Configuration spécifique pour PHP (Intelephense)
        intelephense = function()
            require('lspconfig').intelephense.setup({
                settings = {
                    intelephense = {
                        files = {
                            maxSize = 1000000,
                            associations = { "*.php", "*.phtml", "*.inc", "*.blade.php" },
                        },
                    },
                },
            })
        end,

        -- Configuration pour TypeScript
        ts_ls = function()
            require('lspconfig').ts_ls.setup({ 
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    }
                }
            })
        end,

        -- Configuration lsp solargraph
        solargraph = function()
            require('lspconfig').solargraph.setup({
                settings = {
                    solargraph = {
                        diagnostics = true,
                        completion = true,
                        hover = true,
                        formatting = true,
                    }
                },
            })
        end,
    }
})

-- Configuration autocomplétion
local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

-- ===============================================
-- CONFIGURATION TREESITTER AMÉLIORÉE
-- ===============================================
require('nvim-treesitter.configs').setup {
    -- Langages à installer automatiquement
    ensure_installed = {
        -- Langages web
        "html", "css", "scss", "javascript", "typescript", "tsx", "vue",
        -- Langages backend
        "php", "ruby", "go", "python", "rust", "java", "c", "cpp",
        -- Configuration et markup
        "json", "yaml", "toml", "xml", "sql",
        -- Vim et Lua
        "lua", "vim", "vimdoc",
        -- Documentation
        "markdown", "markdown_inline",
        -- Shell
        "bash", "fish",
        -- Autres
        "regex", "dockerfile", "gitignore", "gitcommit"
    },

    -- Installation automatique des parsers manquants
    sync_install = false,
    auto_install = true,

    -- Configuration de la coloration syntaxique
    highlight = {
        enable = true,
        -- Désactiver vim regex highlighting pour de meilleures performances
        additional_vim_regex_highlighting = false,
        -- Langages pour lesquels désactiver treesitter si nécessaire
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },

    -- Indentation intelligente
    indent = {
        enable = true,
        -- Certains langages peuvent avoir des problèmes d'indentation
        disable = { "python", "yaml" },
    },

    -- Sélection incrémentale basée sur la syntaxe
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },

    -- Navigation dans le code basée sur la syntaxe
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },

    -- Mise en évidence des références
    refactor = {
        highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
        },
        highlight_current_scope = { enable = true },
    },

    -- Rainbow parentheses
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },

    -- Configuration pour différents types de fichiers
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
}

-- ===============================================
-- CONFIGURATION COLORSCHEME OPTIMISÉE
-- ===============================================

-- S'assurer que les couleurs 24-bit sont activées
if vim.fn.has("termguicolors") == 1 then
    vim.opt.termguicolors = true
end

-- Configuration du thème (Tokyo Night est déjà configuré dans lualine)
-- Vous pouvez aussi essayer d'autres thèmes populaires :
vim.cmd([[
    " Activer la coloration syntaxique
    syntax enable

    " Configuration pour de meilleures couleurs
    set background=dark

    " Thème (décommentez celui que vous préférez)
    " colorscheme tokyonight-night
    " colorscheme catppuccin-mocha
    " colorscheme gruvbox
    " colorscheme onedark
]])

-- ===============================================
-- AMÉLIORATIONS SUPPLÉMENTAIRES
-- ===============================================

-- Configuration pour la mise en évidence des mots sous le curseur
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
    end
})

-- Configuration Gitsigns avec plus d'options
require('gitsigns').setup({
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
        follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
})

-- Configuration autopairs
require("nvim-autopairs").setup {}

-- Configuration Comment
require('Comment').setup()

-- Configuration indent-blankline avec de meilleures couleurs
require("ibl").setup({
    indent = {
        char = "│",
        tab_char = "│",
    },
    scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        highlight = { "Function", "Label" },
    },
    exclude = {
        filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
        },
    },
})

-- Configuration bufferline
require("bufferline").setup {
    options = {
        mode = "buffers",
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return "(" .. count .. ")"
        end,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        enforce_regular_tabs = false,
        always_show_bufferline = true,
    }
}

-- Configuration which-key
require("which-key").setup {}

-- Configuration auto-save
require("auto-save").setup {
    enabled = true,
    execution_message = {
        message = function()
            return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
        end,
        dim = 0.18,
        cleaning_interval = 1250,
    },
    trigger_events = { "InsertLeave", "TextChanged" },
    condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        if
            fn.getbufvar(buf, "&modifiable") == 1 and
            utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
            return true
        end
        return false
    end,
    write_all_buffers = false,
    debounce_delay = 135,
    callbacks = {
        enabling = nil,
        disabling = nil,
        before_asserting_save = nil,
        before_saving = nil,
        after_saving = nil
    },
}
