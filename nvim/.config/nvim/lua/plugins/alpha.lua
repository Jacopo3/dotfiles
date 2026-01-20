-- ============================================================================
-- alpha.lua - Dashboard di Benvenuto Personalizzata
-- ============================================================================
-- Alpha-nvim crea una schermata di benvenuto elegante e funzionale
-- che appare quando avvii Neovim senza aprire file
-- ============================================================================

return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        
        -- ================================================================
        -- LOGO ASCII ART
        -- ================================================================
        -- Logo personalizzato per Neovim
        dashboard.section.header.val = {
			
[[         88888 888888888.  8888888888.      ]],
[[         `888  888'   `88b `888'  `888.     ]],
[[          888  888.   .88P  888.  .888'     ]],
[[          8J8  8888B88888'  888R88888'      ]],
[[          888  888'   `88b  888'88b.        ]],
[[          888  888.   .88P  888  `88b.      ]],
[[      .8. 88P  88888888P'  o888o  '888b     ]],
[[      `8888P                                ]],
[[         [ Configurazione Personale ]       ]],
        }
        
        -- ================================================================
        -- PULSANTI/AZIONI PRINCIPALI
        -- ================================================================
        
        dashboard.section.buttons.val = {
            -- Nuovo file
            dashboard.button("n", "  Nuovo File", ":ene <BAR> startinsert <CR>"),
            
            -- Trova file
            dashboard.button("f", "  Cerca File", ":Telescope find_files <CR>"),
            
            -- File recenti
            dashboard.button("r", "  File Recenti", ":Telescope oldfiles <CR>"),
            
            -- Cerca testo
            dashboard.button("g", "  Cerca Testo", ":Telescope live_grep <CR>"),
            
            -- File tree
            dashboard.button("t", "  File Tree", ":NvimTreeToggle <CR>"),
            
            -- File explorer (Oil)
            dashboard.button("e", "  File Explorer", ":Oil <CR>"),
            
            -- Configurazione Neovim
            dashboard.button("c", "  Configurazione", ":e ~/.config/nvim/init.lua <CR>"),
            
            -- Gestione Plugin
            dashboard.button("p", "  Plugin Manager", ":Lazy <CR>"),
            
            -- LSP Manager
            dashboard.button("m", "  LSP Manager", ":Mason <CR>"),
            
            -- Cheat Sheet
            dashboard.button("k", "  Cheat Sheet", ":lua require('config.cheatsheet').toggle() <CR>"),
            
            -- Esci
            dashboard.button("q", "  Esci", ":qa <CR>"),
        }
        
        -- ================================================================
        -- FOOTER CON INFORMAZIONI
        -- ================================================================
        
        -- Funzione per ottenere statistiche
        local function get_stats()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            
            return "⚡ Neovim caricato in " .. ms .. "ms"
                .. "  |  🔌 " .. stats.loaded .. "/" .. stats.count .. " plugins"
        end
        
        -- Funzione per ottenere data e ora
        local function get_datetime()
            local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
            return datetime
        end
        
        dashboard.section.footer.val = {
            " ",
            get_stats(),
            get_datetime(),
            " ",
            "🚀 Leader key: <Space>  |  📚 Cheat Sheet: <Space>k",
        }
        
        -- ================================================================
        -- HIGHLIGHTS (COLORI)
        -- ================================================================
        
        -- Colore header
        dashboard.section.header.opts.hl = "AlphaHeader"
        
        -- Colore footer
        dashboard.section.footer.opts.hl = "AlphaFooter"
        
        -- Colore pulsanti
        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = "AlphaButton"
            button.opts.hl_shortcut = "AlphaShortcut"
        end
        
        -- ================================================================
        -- LAYOUT
        -- ================================================================
        
        dashboard.config.layout = {
            { type = "padding", val = 2 },
            dashboard.section.header,
            { type = "padding", val = 2 },
            dashboard.section.buttons,
            { type = "padding", val = 1 },
            dashboard.section.footer,
        }
        
        -- ================================================================
        -- OPZIONI
        -- ================================================================
        
        dashboard.config.opts.noautocmd = true
        
        -- Disabilita statusline e tabline nel dashboard
        vim.cmd([[
            autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
            autocmd User AlphaReady set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
        ]])
        
        -- ================================================================
        -- SETUP FINALE
        -- ================================================================
        
        alpha.setup(dashboard.config)
        
        -- ================================================================
        -- KEYMAPS PER APRIRE IL DASHBOARD
        -- ================================================================
        
        local keymap = vim.keymap
        
        -- Apri dashboard da qualsiasi buffer
        keymap.set("n", "<leader>h", ":Alpha <CR>", 
            { desc = "Open dashboard (home)" })
        
        -- ================================================================
        -- DEFINISCI HIGHLIGHTS PERSONALIZZATI
        -- ================================================================
        
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                -- Header (logo) in blu/cyan
                vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#89dceb", bold = true })
                
                -- Footer in grigio
                vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6c7086", italic = true })
                
                -- Pulsanti in verde
                vim.api.nvim_set_hl(0, "AlphaButton", { fg = "#a6e3a1" })
                
                -- Shortcuts (lettere) in rosa
                vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f38ba8", bold = true })
            end,
        })
    end,
}

-- ============================================================================
-- COME USARE IL DASHBOARD
-- ============================================================================
-- 
-- Il dashboard appare automaticamente quando:
-- 1. Avvii Neovim senza argomenti: nvim
-- 2. Apri Neovim in una directory: nvim .
-- 
-- NAVIGAZIONE NEL DASHBOARD:
-- - Usa j/k per muoverti tra i pulsanti
-- - Premi Enter sulla voce che vuoi selezionare
-- - Oppure premi la lettera indicata (n, f, r, etc.)
-- 
-- RIAPRIRE IL DASHBOARD:
-- - Da qualsiasi buffer, premi <leader>h (SPAZIO + h)
-- - Oppure usa il comando :Alpha
-- 
-- PERSONALIZZAZIONE:
-- - Modifica il logo in dashboard.section.header.val
-- - Aggiungi/rimuovi pulsanti in dashboard.section.buttons.val
-- - Cambia i colori modificando gli highlight
-- 
-- ============================================================================

-- ============================================================================
-- STATISTICHE MOSTRATE
-- ============================================================================
-- 
-- Il footer mostra automaticamente:
-- - Tempo di avvio di Neovim (quanto veloce si carica)
-- - Numero di plugin caricati / totali installati
-- - Data e ora corrente
-- - Reminder del leader key e cheat sheet
-- 
-- ============================================================================
