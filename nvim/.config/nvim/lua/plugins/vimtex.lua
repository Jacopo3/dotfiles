-- ============================================================================
-- vimtex.lua - Configurazione VimTeX per LaTeX
-- ============================================================================
-- VimTeX fornisce:
-- - Compilazione automatica
-- - Visualizzazione PDF integrata
-- - Navigazione tra sorgente e PDF (synctex)
-- - Autocompletamento avanzato
-- - Text objects specifici per LaTeX
-- ============================================================================

return {
	"lervag/vimtex",
	ft = "tex",  -- Carica solo per file .tex

	config = function()
		-- ================================================================
		-- CONFIGURAZIONE GENERALE
		-- ================================================================

		-- Abilita VimTeX
		vim.g.vimtex_enabled = 1

		-- Compilatore da usare (latexmk è il più versatile)
		vim.g.vimtex_compiler_method = "latexmk"

		-- Opzioni per latexmk
		vim.g.vimtex_compiler_latexmk = {
			build_dir = "",           -- Directory output (vuoto = stessa dir)
			callback = 1,             -- Callback dopo compilazione
			continuous = 1,           -- Compilazione continua
			executable = "latexmk",   -- Eseguibile
			options = {
				"-pdf",                    -- Genera PDF
				"-verbose",                -- Output verboso
				"-file-line-error",        -- Errori con numero linea
				"-synctex=1",             -- Abilita synctex
				"-interaction=nonstopmode", -- Non fermarsi agli errori
				"-f"						--Test perché rompe
			},
		}

		-- ================================================================
		-- VISUALIZZATORE PDF
		-- ================================================================

		-- Metodo di visualizzazione (scegli in base al tuo sistema)
		-- Opzioni comuni: zathura (Linux), skim (macOS), sumatraPDF (Windows)
		-- vim.g.vimtex_view_method = "general"  -- Cambia se usi altro viewer

		-- Opzioni specifiche per zathura
		-- vim.g.vimtex_view_zathura_options = "-reuse-instance"

		-- Per macOS (Skim):
		-- vim.g.vimtex_view_method = "skim"

		-- Per Windows (SumatraPDF):
		-- vim.g.vimtex_view_general_viewer = "SumatraPDF"
		-- vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"

		-- ================================================================
		-- QUICKFIX E ERRORI
		-- ================================================================

		-- Apri automaticamente quickfix quando ci sono errori
		vim.g.vimtex_quickfix_mode = 2
		vim.g.vimtex_quickfix_open_on_xz = 0

		-- Modalità quickfix (0 = mai, 1 = sempre, 2 = solo errori)
		vim.g.vimtex_quickfix_open_on_warning = 0
		-- Ignora alcuni warning comuni
		vim.g.vimtex_quickfix_ignore_filters = {
			"Underfull",
			"Overfull",
			"specifier changed to",
			"Double superscript",
		}

		-- ================================================================
		-- FOLDING (pieghevole del codice)
		-- ================================================================

		-- Abilita folding
		vim.g.vimtex_fold_enabled = 1

		-- Metodo di folding (manual, indent, expr, marker, syntax, diff)
		vim.g.vimtex_fold_manual = 0

		-- ================================================================
		-- INDENTAZIONE
		-- ================================================================

		-- Abilita indentazione automatica
		vim.g.vimtex_indent_enabled = 1

		-- ================================================================
		-- CONCEALMENT (nasconde comandi LaTeX)
		-- ================================================================

		-- Livello di concealment (0 = off, 1 = on, 2 = aggressive)
		vim.g.vimtex_syntax_conceal = {
			accents = 1,		-- Mostra caratteri accentati
			ligatures = 1,		-- Mostra legature
			cites = 1,			-- Nascondi \cite
			fancy = 1,			-- Simboli matematici
			spacing = 0,		-- Non nascondere spaziatura
			greek = 1,			-- Lettere greche
			math_bounds = 0,	-- Non nascondere $ $
			math_delimiters = 1,-- Delimitatori matematici
			math_fracs = 1,    	-- Frazioni
			math_super_sub = 1, -- Apici e pedici
			math_symbols = 1,   -- Simboli matematici
			sections = 0,       -- Non nascondere sezioni
			styles = 1,         -- Stili (bold, italic)
		}

		-- ================================================================
		-- TABLE OF CONTENTS
		-- ================================================================

		-- Larghezza TOC
		vim.g.vimtex_toc_config = {
			name = "TOC",
			layers = { "content", "todo", "include" },
			split_width = 50,
			todo_sorted = 0,
			show_help = 1,
			show_numbers = 1,
		}

		-- ================================================================
		-- IMPOSTAZIONI BUFFER LOCALI PER FILE TEX
		-- ================================================================

		-- Autocmd per file .tex
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "tex",
			callback = function()
				-- Abilita spell checking per LaTeX
				vim.opt_local.spell = true
				vim.opt_local.spelllang = "it,en"

				-- Wrapping per testo lungo
				vim.opt_local.wrap = true
				vim.opt_local.linebreak = true

				-- Indentazione per LaTeX
				vim.opt_local.shiftwidth = 2
				vim.opt_local.tabstop = 2
			end,
		})

		-- ================================================================
		-- KEYMAPS VIMTEX
		-- ================================================================

		local keymap = vim.keymap

		-- Compila documento
		keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>",
			{ desc = "VimTeX: Compile document" })

		-- Stop compilazione
		keymap.set("n", "<leader>lk", "<cmd>VimtexStop<CR>",
			{ desc = "VimTeX: Stop compilation" })

		-- Pulisci file ausiliari
		keymap.set("n", "<leader>lc", "<cmd>VimtexClean<CR>",
			{ desc = "VimTeX: Clean auxiliary files" })

		-- Visualizza PDF
		keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>",
			{ desc = "VimTeX: View PDF" })

		-- Apri table of contents
		keymap.set("n", "<leader>lt", "<cmd>VimtexTocOpen<CR>",
			{ desc = "VimTeX: Open table of contents" })

		-- Info VimTeX
		keymap.set("n", "<leader>li", "<cmd>VimtexInfo<CR>",
			{ desc = "VimTeX: Show info" })

		-- Questo è il comando richiesto per VimtexSetMain
		keymap.set("n", "<leader>lm", "<cmd>VimtexSetMainFile<CR>",
			{ desc = "VimTeX: Set main file" })

		-- Errori di compilazione
		keymap.set("n", "<leader>le", "<cmd>VimtexErrors<CR>",
			{ desc = "VimTeX: Show compilation errors" })

		-- Conta parole
		keymap.set("n", "<leader>lw", "<cmd>VimtexCountWords<CR>",
			{ desc = "VimTeX: Count words" })

		-- Forward search (da sorgente a PDF)
		keymap.set("n", "<leader>ls", "<cmd>VimtexView<CR>",
			{ desc = "VimTeX: Forward search (source to PDF)" })
	end,
}

-- ============================================================================
-- NOTE INSTALLAZIONE
-- ============================================================================
-- DIPENDENZE NECESSARIE:
-- 
-- 1. Distribuzione LaTeX:
--    Ubuntu/Debian: sudo apt install texlive-full latexmk
--    macOS: brew install --cask mactex
--    Arch: sudo pacman -S texlive-most texlive-lang
--    Windows: Installa MiKTeX o TeXLive
-- 
-- 2. Visualizzatore PDF con SyncTeX:
--    Linux - Zathura:
--      Ubuntu/Debian: sudo apt install zathura
--      Arch: sudo pacman -S zathura zathura-pdf-mupdf
--    
--    macOS - Skim:
--      brew install --cask skim
--    
--    Windows - SumatraPDF:
--      Scarica da https://www.sumatrapdfreader.org/
-- 
-- 3. (Opzionale) Spell checker:
--    Ubuntu/Debian: sudo apt install hunspell hunspell-it hunspell-en-us
-- 
-- ============================================================================
-- COME USARE VIMTEX
-- ============================================================================
-- 1. Apri un file .tex
-- 2. Usa <leader>ll per compilare (si avvia compilazione continua)
-- 3. Usa <leader>lv per aprire/visualizzare il PDF
-- 4. Usa <leader>lm per impostare il file corrente come main (per progetti multi-file)
-- 5. Modifica il .tex e salva - il PDF si aggiorna automaticamente
-- 6. Usa <leader>lk per fermare la compilazione
-- 7. Usa <leader>lc per pulire file ausiliari
-- 
-- Per progetti multi-file:
-- - Nel file main, aggiungi: % !TEX root = main.tex
-- - Oppure usa <leader>lm nel file main per impostarlo
-- 
-- FORWARD SEARCH (da .tex a PDF):
-- - Posiziona cursore su una riga e premi <leader>ls
-- - Il viewer salta alla posizione corrispondente nel PDF
-- 
-- BACKWARD SEARCH (da PDF a .tex):
-- - In zathura: Ctrl+click sulla posizione nel PDF
-- - In Skim: Cmd+Shift+click
-- - Neovim salta alla posizione corrispondente nel sorgente
-- ============================================================================
