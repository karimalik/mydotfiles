-- lua/keymaps.lua

local keymap = vim.keymap.set
local opts = { silent = true }

-- Raccourcis généraux
keymap("n", "<leader>w", ":w<CR>", opts) -- Sauvegarder
keymap("n", "<leader>q", ":q<CR>", opts) -- Quitter
keymap("n", "<leader>wq", ":wq<CR>", opts) -- Sauvegarder et quitter

-- Navigation entre les buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts) -- Fermer buffer

-- Navigation entre les fenêtres
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Redimensionner les fenêtres
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Naviguer dans le texte en mode visuel
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Déplacer le texte en mode visuel
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Déplacer le texte en mode visuel bloc
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- NvimTree (Explorateur de fichiers)
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>f", ":NvimTreeFocus<CR>", opts)

-- Telescope (Recherche de fichiers)
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)

-- LSP (Diagnostic et navigation)
keymap("n", "<leader>d", vim.diagnostic.open_float, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "<leader>dl", vim.diagnostic.setloclist, opts)

-- Raccourcis spécifiques aux langages

-- PHP Laravel
keymap("n", "<leader>pa", ":!php artisan ", { silent = false }) -- Commande artisan
keymap("n", "<leader>pr", ":!php artisan route:list<CR>", opts) -- Liste des routes
keymap("n", "<leader>pm", ":!php artisan make:", { silent = false }) -- Make commands

-- Ruby on Rails
keymap("n", "<leader>rc", ":!rails console<CR>", opts) -- Rails console
keymap("n", "<leader>rs", ":!rails server<CR>", opts) -- Rails server
keymap("n", "<leader>rg", ":!rails generate ", { silent = false }) -- Rails generate
keymap("n", "<leader>rdb", ":!rails db:migrate<CR>", opts) -- Database migrate

-- Go
keymap("n", "<leader>gr", ":!go run %<CR>", opts) -- Run current Go file
keymap("n", "<leader>gb", ":!go build<CR>", opts) -- Build Go project
keymap("n", "<leader>gt", ":!go test<CR>", opts) -- Run tests

-- Node.js / JavaScript / TypeScript
keymap("n", "<leader>ni", ":!npm install<CR>", opts) -- npm install
keymap("n", "<leader>ns", ":!npm start<CR>", opts) -- npm start
keymap("n", "<leader>nt", ":!npm test<CR>", opts) -- npm test
keymap("n", "<leader>nr", ":!npm run ", { silent = false }) -- npm run

-- Git (avec terminal intégré)
keymap("n", "<leader>gs", ":!git status<CR>", opts)
keymap("n", "<leader>ga", ":!git add .<CR>", opts)
keymap("n", "<leader>gc", ":!git commit -m ", { silent = false })
keymap("n", "<leader>gp", ":!git push<CR>", opts)
keymap("n", "<leader>gl", ":!git log --oneline<CR>", opts)

-- Terminal intégré
keymap("n", "<leader>t", ":terminal<CR>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts) 

-- Formatage
keymap("n", "<leader>lf", vim.lsp.buf.format, opts) -- Format avec LSP

-- Raccourcis pour auto-save
keymap("n", "<leader>as", ":ASToggle<CR>", opts) -- Toggle auto-save

-- Effacer la recherche
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)