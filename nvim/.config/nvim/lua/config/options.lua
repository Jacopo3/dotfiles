-- ============================================================================
-- options.lua - Opzioni generali di Neovim
-- ============================================================================
-- Questo file configura il comportamento base dell'editor
-- ============================================================================

local opt = vim.opt

-- Numeri di riga
opt.number = true				-- Mostra i numeri di riga
opt.relativenumber = false  	-- Numeri relativi alla riga corrente (utile per movimenti)

-- Indentazione
opt.tabstop = 4           		-- Una tab corrisponde a 4 spazi
opt.shiftwidth = 4        		-- Indentazione automatica di 4 spazi
opt.expandtab = false      		-- Converte tab in spazi
opt.autoindent = true     		-- Mantiene l'indentazione della riga precedente
opt.smartindent = true    		-- Indentazione intelligente per codice

-- Ricerca
opt.ignorecase = true     		-- Ignora maiuscole/minuscole nella ricerca
opt.smartcase = true      		-- Ma le considera se digiti maiuscole

-- Aspetto
opt.termguicolors = true  		-- Abilita colori a 24-bit (necessario per temi moderni)
opt.cursorline = true     		-- Evidenzia la riga corrente
opt.signcolumn = "yes"    		-- Mostra sempre la colonna per i segni (diagnostici LSP)
opt.wrap = false          		-- Non va a capo automaticamente

-- Splitting finestre
opt.splitbelow = true     		-- Split orizzontale in basso
opt.splitright = true     		-- Split verticale a destra

-- Clipboard
opt.clipboard = "unnamedplus"  	-- Usa la clipboard del sistema

-- Backup e swap
opt.swapfile = false      		-- Disabilita file di swap
opt.backup = false        		-- Disabilita backup
opt.undofile = true       		-- Abilita undo persistente

-- Scroll
opt.scrolloff = 8         		-- Mantieni 8 righe visibili sopra/sotto il cursore

-- Mouse
opt.mouse = "a"           		-- Abilita il mouse in tutte le modalità

-- Tempi di aggiornamento
opt.updatetime = 250      		-- Tempo di aggiornamento più veloce (ms)
opt.timeoutlen = 500      		-- Tempo di attesa per sequenze di tasti (ms)
