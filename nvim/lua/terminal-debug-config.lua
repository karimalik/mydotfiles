-- lua/terminal-debug-config.lua

-- ===============================================
-- CONFIGURATION TOGGLETERM (TERMINAL INTÉGRÉ)
-- ===============================================
require('toggleterm').setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'horizontal',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        }
    }
})

-- Fonctions personnalisées pour les terminaux
local Terminal = require('toggleterm.terminal').Terminal

-- Terminal flottant personnalisé
local float_term = Terminal:new({
    cmd = "powershell" or "bash",
    hidden = true,
    direction = "float",
    float_opts = {
        border = "double",
    },
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(
            term.bufnr,
            "t",
            "<esc>",
            [[<C-\><C-n>]],
            { noremap = true, silent = true }
        )
    end,
})

function _G.toggle_float()
    float_term:toggle()
end

-- Terminal Git personnalisé
local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    direction = "float",
    hidden = true,
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(
            term.bufnr,
            "t",
            "<esc>",
            [[<C-\><C-n>]],
            { noremap = true, silent = true }
        )
    end,
})

function _G.toggle_lazygit()
    lazygit:toggle()
end

-- ===============================================
-- CONFIGURATION DAP (DÉBOGAGE)
-- ===============================================
local dap = require('dap')
local dapui = require('dapui')

-- Configuration UI
dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 },
                "breakpoints",
                "stacks",
                "watches",
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                "repl",
                "console",
            },
            size = 0.25,
            position = "bottom",
        },
    },
    floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
})

-- Événements automatiques pour DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- Texte virtuel pour les variables
require("nvim-dap-virtual-text").setup({
    enabled = true,
    all_frames = true,
})

-- Intégration Telescope
require('telescope').load_extension('dap')

-- ===============================================
-- CONFIGURATIONS SPÉCIFIQUES AUX LANGAGES
-- ===============================================

-- Configuration PHP 
dap.adapters.php = {
    type = 'executable',
    command = 'node',
}

dap.configurations.php = {
    {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}"
        }
    }
}

-- Configuration Go
require('dap-go').setup({
    dap_configurations = {
        {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}"
        },
        {
            type = "go",
            name = "Debug test",
            request = "launch",
            mode = "test",
            program = "${file}"
        },
        {
            type = "go",
            name = "Debug package",
            request = "launch",
            program = "${fileDirname}"
        }
    },
    delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        port = "${port}",
        args = {}
    },
})

-- Configuration Python
require('dap-python').setup('python', {
    include_configs = true,
    configurations = {
        {
            type = 'python',
            request = 'launch',
            name = 'Python: Fichier actuel',
            program = '${file}',
            pythonPath = function()
                return 'python'
            end,
        },
    }
})

-- Configuration JavaScript/TypeScript
dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
}

dap.configurations.javascript = {
    {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
    }
}

dap.configurations.typescript = {
    {
        name = 'Debug TS',
        type = 'node2',
        request = 'launch',
        program = '${workspaceFolder}/${fileBasenameNoExtension}.js',
        sourceMaps = true,
        outFiles = { '${workspaceFolder}/dist/**/*.js' },
        protocol = 'inspector',
        console = 'integratedTerminal',
    }
}

-- ===============================================
-- RACCOURIS PERSONNALISÉS SUPPLEMENTAIRES
-- ===============================================
local opts = { silent = true }

-- Inspecteur de variables
vim.keymap.set('n', '<leader>dv', function()
    require('dap.ui.widgets').hover()
end, opts)

-- Évaluer l'expression sous le curseur
vim.keymap.set('n', '<leader>de', function()
    require('dap.ui.widgets').centered_float(
        require('dap.ui.widgets').expression,
        { border = 'single' }
    )
end, opts)

-- Terminal REPL DAP
vim.keymap.set('n', '<leader>dr', require('dap').repl.toggle, opts)

-- Lancer une session de débogage
vim.keymap.set('n', '<leader>dl', require('dap').run_last, opts)

-- Basculer le terminal flottant personnalisé
vim.keymap.set('n', '<leader>gf', '<cmd>lua toggle_float()<CR>', opts)

-- Basculer lazygit
vim.keymap.set('n', '<leader>gg', '<cmd>lua toggle_lazygit()<CR>', opts)

-- Démarrer le débogage avec le fichier actuel
vim.keymap.set('n', '<leader>df', function()
    local filetype = vim.bo.filetype
    if filetype == 'go' then
        require('dap-go').debug_test()
    elseif filetype == 'python' then
        require('dap-python').test_method()
    else
        require('dap').continue()
    end
end, opts)
