-- ============================================================================
-- init.lua - Punto di ingresso principale per Neovim
-- ============================================================================
-- Questo file viene caricato automaticamente all'avvio di Neovim
-- Si occupa di:
-- 1. Impostare il leader key (tasto principale per le shortcuts)
-- 2. Caricare le opzioni generali
-- 3. Caricare le keymaps (scorciatoie da tastiera)
-- 4. Inizializzare lazy.nvim (gestore plugin)
-- ============================================================================

-- Imposta il leader key a SPAZIO
-- Il leader è il tasto che precede molte scorciatoie personalizzate
-- Esempio: <leader>k diventa SPAZIO+k
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Carica le opzioni generali di Neovim
-- Contiene impostazioni come numeri di riga, indentazione, ecc.
require("config.options")

-- Carica le scorciatoie da tastiera globali
-- Shortcuts che non dipendono da plugin specifici
require("config.keymaps")

-- Inizializza lazy.nvim (gestore plugin)
-- Questo deve essere caricato prima di qualsiasi plugin
require("config.lazy")

-- Carica il cheat sheet (non è un plugin, è un modulo locale)
require("config.cheatsheet").setup()
