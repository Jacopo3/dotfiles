-- ============================================================================
-- telescope.lua - Configurazione Telescope (fuzzy finder)
-- ============================================================================
-- Telescope è uno strumento per cercare file, testo, simboli e altro
-- attraverso un'interfaccia interattiva
-- ============================================================================

return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",  -- Libreria di utilità richiesta
		{
			"nvim-telescope/telescope-fzf-native.nvim",  -- Migliora performance
			build = "make",  -- Compila componente nativo
		},
		"nvim-tree/nvim-web-devicons",  -- Icone per i file
	},

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		-- Configurazione principale
		telescope.setup({
			defaults = {
				-- Percorso per ripple effect
				path_display = { "smart" },  -- Mostra percorsi in modo intelligente

				-- Mappings all'interno di telescope
				mappings = {
					i = {  -- Insert mode
						["<C-k>"] = actions.move_selection_previous,  -- Su
						["<C-j>"] = actions.move_selection_next,      -- Giù
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},

			-- Configurazioni specifiche per pickers
			pickers = {
				find_files = {
					theme = "dropdown",  -- Usa tema dropdown
					previewer = false,   -- Disabilita anteprima per velocità
					hidden = true,       -- Mostra file nascosti
				},
			},
		})

		-- Carica estensione fzf-native per migliori performance
		telescope.load_extension("fzf")

		-- ====================================================================
		-- KEYMAPS TELESCOPE
		-- ====================================================================
		local keymap = vim.keymap

		-- Cerca file nel progetto
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",
			{ desc = "Fuzzy find files in cwd" })

		-- Cerca file recenti
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",
			{ desc = "Fuzzy find recent files" })

		-- Cerca testo nel progetto (live grep)
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",
			{ desc = "Find string in cwd" })

		-- Cerca parola sotto il cursore
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>",
			{ desc = "Find string under cursor in cwd" })

		-- Cerca nei buffer aperti
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>",
			{ desc = "Find in open buffers" })

		-- Cerca nei comandi disponibili
		keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",
			{ desc = "Find help tags" })

		-- Cerca nei keymaps definiti
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>",
			{ desc = "Find keymaps" })

		-- Cerca nei file di configurazione Neovim
		keymap.set("n", "<leader>fn", function()
			require("telescope.builtin").find_files({
				cwd = vim.fn.stdpath("config")
			})
		end, { desc = "Find Neovim config files" })
	end,
}

-- ============================================================================
-- NOTE INSTALLAZIONE
-- ============================================================================
-- Per telescope-fzf-native è necessario avere installato:
-- - make
-- - gcc o clang
-- 
-- Su Ubuntu/Debian:
--   sudo apt install build-essential
-- 
-- Su macOS (con Homebrew):
--   xcode-select --install
-- 
-- Su Arch:
--   sudo pacman -S base-devel
-- ============================================================================
