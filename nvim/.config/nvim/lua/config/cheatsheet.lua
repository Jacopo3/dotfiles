-- ============================================================================
-- cheatsheet.lua - Modulo Cheat Sheet (NON è un plugin)
-- ============================================================================
-- Questo file contiene solo funzioni, verrà caricato da init.lua
-- ============================================================================

local M = {}

-- ================================================================
-- DEFINIZIONE SHORTCUTS
-- ================================================================
local shortcuts = {
	{
		category = "GENERALE",
		items = {
			{ key = "<Space>", desc = "Leader key" },
			{ key = "<leader>w", desc = "Salva file" },
			{ key = "<leader>q", desc = "Salva ed esci" },
			{ key = "<leader>Q", desc = "Esci senza salvare" },
			{ key = "<leader>nh", desc = "Rimuovi evidenziazione ricerca" },
		}
	},

	{
		category = "NAVIGAZIONE FINESTRE",
		items = {
			{ key = "<C-h>", desc = "Vai a finestra sinistra" },
			{ key = "<C-j>", desc = "Vai a finestra sotto" },
			{ key = "<C-k>", desc = "Vai a finestra sopra" },
			{ key = "<C-l>", desc = "Vai a finestra destra" },
			{ key = "<leader>sv", desc = "Split verticale" },
			{ key = "<leader>sh", desc = "Split orizzontale" },
			{ key = "<leader>se", desc = "Uguaglia dimensioni split" },
			{ key = "<leader>sx", desc = "Chiudi split corrente" },
		}
	},

	{
		category = "TAB",
		items = {
			{ key = "<leader>to", desc = "Apri nuovo tab" },
			{ key = "<leader>tx", desc = "Chiudi tab corrente" },
			{ key = "<leader>tn", desc = "Vai al prossimo tab" },
			{ key = "<leader>tp", desc = "Vai al tab precedente" },
		}
	},

	{
		category = "BUFFER",
		items = {
			{ key = "<leader>bn", desc = "Prossimo buffer" },
			{ key = "<leader>bp", desc = "Buffer precedente" },
			{ key = "<leader>bd", desc = "Chiudi buffer corrente" },
		}
	},

	{
		category = "FOLDING (PIEGATURA CODICE)",
		items = {
			{ key = "za", desc = "Toggle fold (apri/chiudi)" },
			{ key = "zc", desc = "Chiudi fold corrente" },
			{ key = "zo", desc = "Apri fold corrente" },
			{ key = "zC", desc = "Chiudi tutti i fold ricorsivamente" },
			{ key = "zO", desc = "Apri tutti i fold ricorsivamente" },
			{ key = "zM", desc = "Chiudi tutti i fold nel file" },
			{ key = "zR", desc = "Apri tutti i fold nel file" },
			{ key = "zj", desc = "Vai al prossimo fold" },
			{ key = "zk", desc = "Vai al fold precedente" },
			{ key = "zd", desc = "Elimina fold corrente" },
			{ key = "zE", desc = "Elimina tutti i fold nel file" },
		}
	},

	{
		category = "TELESCOPE (RICERCA)",
		items = {
			{ key = "<leader>ff", desc = "Cerca file nel progetto" },
			{ key = "<leader>fr", desc = "Cerca file recenti" },
			{ key = "<leader>fs", desc = "Cerca testo nel progetto (grep)" },
			{ key = "<leader>fc", desc = "Cerca parola sotto cursore" },
			{ key = "<leader>fb", desc = "Cerca nei buffer aperti" },
			{ key = "<leader>fh", desc = "Cerca nell'help" },
			{ key = "<leader>fk", desc = "Cerca keymaps" },
			{ key = "<leader>fn", desc = "Cerca nei file config Neovim" },
		}
	},

	{
		category = "NVIM-TREE (FILE TREE)",
		items = {
			{ key = "<leader>t", desc = "Toggle file tree" },
			{ key = "<leader>tf", desc = "Focus su file tree" },
			{ key = "<leader>tc", desc = "Trova file corrente nel tree" },
			{ key = "<leader>tq", desc = "Chiudi file tree" },
			{ key = "<leader>tr", desc = "Refresh file tree" },
			{ key = "<CR>", desc = "[Tree] Apri file/cartella" },
			{ key = "a", desc = "[Tree] Crea file/cartella" },
			{ key = "d", desc = "[Tree] Cancella file/cartella" },
			{ key = "r", desc = "[Tree] Rinomina file/cartella" },
		}
	},

	{
		category = "OIL (FILE MANAGER)",
		items = {
			{ key = "<leader>e", desc = "Apri Oil nella directory corrente" },
			{ key = "<leader>E", desc = "Apri Oil in working directory" },
			{ key = "<leader>-", desc = "Apri Oil in finestra floating" },
			{ key = "<CR>", desc = "[Oil] Apri file/cartella" },
			{ key = "g.", desc = "[Oil] Mostra/nascondi file nascosti" },
			{ key = "-", desc = "[Oil] Vai alla directory padre" },
		}
	},

	{
		category = "LSP (LANGUAGE SERVER)",
		items = {
			{ key = "K", desc = "Mostra documentazione hover" },
			{ key = "gd", desc = "Vai alla definizione" },
			{ key = "gD", desc = "Vai alla dichiarazione" },
			{ key = "gi", desc = "Vai all'implementazione" },
			{ key = "gr", desc = "Mostra riferimenti" },
			{ key = "<leader>d", desc = "Mostra diagnostici linea" },
			{ key = "[d", desc = "Diagnostico precedente" },
			{ key = "]d", desc = "Diagnostico successivo" },
			{ key = "<leader>ca", desc = "Code actions" },
			{ key = "<leader>rn", desc = "Rinomina simbolo" },
			{ key = "<leader>fm", desc = "Formatta file" },
		}
	},

	{
		category = "COMPLETAMENTO",
		items = {
			{ key = "<C-k>", desc = "[Completamento] Opzione precedente" },
			{ key = "<C-j>", desc = "[Completamento] Opzione successiva" },
			{ key = "<C-Space>", desc = "[Completamento] Mostra suggerimenti" },
			{ key = "<CR>", desc = "[Completamento] Conferma selezione" },
			{ key = "<C-e>", desc = "[Completamento] Chiudi" },
		}
	},

	{
		category = "TREESITTER (TEXT OBJECTS)",
		items = {
			{ key = "<C-space>", desc = "Inizia/espandi selezione" },
			{ key = "<BS>", desc = "Restringi selezione" },
			{ key = "af", desc = "Seleziona funzione intera" },
			{ key = "if", desc = "Seleziona corpo funzione" },
			{ key = "ac", desc = "Seleziona classe intera" },
			{ key = "ic", desc = "Seleziona corpo classe" },
			{ key = "]f", desc = "Vai a prossima funzione" },
			{ key = "[f", desc = "Vai a funzione precedente" },
			{ key = "]c", desc = "Vai a prossima classe" },
			{ key = "[c", desc = "Vai a classe precedente" },
		}
	},

	{
		category = "VIMTEX (LaTeX)",
		items = {
			{ key = "<leader>ll", desc = "Compila documento LaTeX" },
			{ key = "<leader>lk", desc = "Stop compilazione" },
			{ key = "<leader>lc", desc = "Pulisci file ausiliari" },
			{ key = "<leader>lv", desc = "Visualizza PDF" },
			{ key = "<leader>lt", desc = "Apri table of contents" },
			{ key = "<leader>li", desc = "Info VimTeX" },
			{ key = "<leader>lm", desc = "Imposta file come main" },
			{ key = "<leader>le", desc = "Mostra errori compilazione" },
			{ key = "<leader>lw", desc = "Conta parole" },
			{ key = "<leader>ls", desc = "Forward search (tex → PDF)" },
		}
	},

	{
		category = "EDITING",
		items = {
			{ key = "<", desc = "[Visual] Indenta sinistra" },
			{ key = ">", desc = "[Visual] Indenta destra" },
			{ key = "J", desc = "[Visual] Sposta righe giù" },
			{ key = "K", desc = "[Visual] Sposta righe su" },
			{ key = "<C-d>", desc = "Scroll giù (centrato)" },
			{ key = "<C-u>", desc = "Scroll su (centrato)" },
			{ key = "n", desc = "Ricerca successiva (centrata)" },
			{ key = "N", desc = "Ricerca precedente (centrata)" },
		}
	},

	{
		category = "DASHBOARD & UTILITY",
		items = {
			{ key = "<leader>h", desc = "Apri dashboard (home)" },
			{ key = "<leader>k", desc = "Apri/Chiudi questo cheat sheet" },
			{ key = "q", desc = "[Cheat Sheet] Chiudi cheat sheet" },
		}
	},
}

-- ================================================================
-- FUNZIONE PER CREARE IL CHEAT SHEET
-- ================================================================
local function create_cheatsheet()
	local width = math.min(100, vim.o.columns - 4)
	local height = math.min(40, vim.o.lines - 4)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	local lines = {}

	table.insert(lines, "╔═══════════════════════════════════════════════════════════════════════════╗")
	table.insert(lines, "║                          NEOVIM CHEAT SHEET                               ║")
	table.insert(lines, "║                    Premi 'q' per chiudere questa finestra                 ║")
	table.insert(lines, "╚═══════════════════════════════════════════════════════════════════════════╝")
	table.insert(lines, "")

	for _, section in ipairs(shortcuts) do
		table.insert(lines, "┌─ " .. section.category .. " " .. string.rep("─", 70 - #section.category))
		table.insert(lines, "│")

		local max_key_len = 0
		for _, item in ipairs(section.items) do
			max_key_len = math.max(max_key_len, #item.key)
		end

		for _, item in ipairs(section.items) do
			local padding = string.rep(" ", max_key_len - #item.key)
			table.insert(lines, "│  " .. item.key .. padding .. "  →  " .. item.desc)
		end

		table.insert(lines, "│")
		table.insert(lines, "")
	end

	table.insert(lines, "")
	table.insert(lines, "═══════════════════════════════════════════════════════════════════════════")
	table.insert(lines, "  Leader key = <Space>  |  Configurazione: ~/.config/nvim/")
	table.insert(lines, "═══════════════════════════════════════════════════════════════════════════")

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.wo[win].cursorline = true

	local opts = { noremap = true, silent = true, buffer = buf }
	vim.keymap.set("n", "q", "<cmd>close<CR>", opts)
	vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", opts)
	vim.keymap.set("n", "<leader>k", "<cmd>close<CR>", opts)

	vim.bo[buf].filetype = "cheatsheet"

	vim.cmd([[
		syntax match CheatSheetBorder /[╔═╗║╚┌─│]/
		syntax match CheatSheetArrow /→/
		syntax match CheatSheetKey /<[^>]*>/
		syntax match CheatSheetCategory /^┌─ .*$/
		
		highlight CheatSheetBorder guifg=#89dceb
		highlight CheatSheetArrow guifg=#f38ba8
		highlight CheatSheetKey guifg=#a6e3a1 gui=bold
		highlight CheatSheetCategory guifg=#f9e2af gui=bold
	]])
end

-- ================================================================
-- TOGGLE CHEAT SHEET (funzione pubblica)
-- ================================================================
function M.toggle()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "cheatsheet" then
			vim.api.nvim_win_close(win, true)
			return
		end
	end

	create_cheatsheet()
end

-- ================================================================
-- SETUP (chiamato da init.lua)
-- ================================================================
function M.setup()
	vim.keymap.set("n", "<leader>k", M.toggle,
		{ noremap = true, silent = true, desc = "Toggle cheat sheet" })

	vim.api.nvim_create_user_command("CheatSheet", M.toggle, {
		desc = "Apri/chiudi cheat sheet"
	})
end

return M
