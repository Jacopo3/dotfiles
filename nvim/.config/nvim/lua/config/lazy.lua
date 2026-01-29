-- ============================================================================
-- lazy.lua - Configurazione del gestore plugin lazy.nvim
-- ============================================================================

-- Path dove lazy.nvim verrà installato
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Controlla se lazy.nvim è già installato
-- Se non lo è, lo clona automaticamente da GitHub
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",  -- Clona senza scaricare tutti i blob (più veloce)
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",     -- Usa la branch stabile
        lazypath,
    })
end

-- Aggiungi lazy.nvim al runtime path di Neovim
vim.opt.rtp:prepend(lazypath)

-- Configura e carica tutti i plugin
require("lazy").setup({
	-- Carica tutti i file nella directory lua/plugins/
	-- Ogni file in quella directory definirà uno o più plugin
	{ import = "plugins" },
}, {
	-- Opzioni di lazy.nvim
	checker = {
		enabled = true,      -- Controlla automaticamente aggiornamenti
		notify = true,      -- Mostrare notifiche per aggiornamenti
	},
	change_detection = {
		notify = true,      -- Notificare quando i file di config cambiano
	},
})

-- ============================================================================
-- COMANDI UTILI PER GESTIRE I PLUGIN
-- ============================================================================
-- :Lazy              - Apri l'interfaccia di lazy.nvim
-- :Lazy update       - Aggiorna tutti i plugin
-- :Lazy sync         - Installa/aggiorna/pulisci plugin
-- :Lazy clean        - Rimuovi plugin non più usati
-- :Lazy check        - Controlla aggiornamenti disponibili
-- ============================================================================
