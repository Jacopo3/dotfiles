-- ============================================================================
-- colorscheme.lua - Configurazione tema Catppuccin
-- ============================================================================
-- Catppuccin è un tema moderno con 4 varianti:
-- - latte (chiaro)
-- - frappe (medio)
-- - macchiato (scuro)
-- - mocha (molto scuro)
-- ============================================================================

return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,  -- Carica prima di altri plugin (importante per il tema)
    
    config = function()
        require("catppuccin").setup({
            -- Scegli la variante (latte, frappe, macchiato, mocha)
            flavour = "mocha",  -- Tema scuro principale
            
            -- Abilita supporto per vari plugin
            integrations = {
                telescope = {
                    enabled = true,
                },
                treesitter = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                },
            },
            
            -- Stili personalizzati
            styles = {
                comments = { "italic" },      -- Commenti in corsivo
                conditionals = { "italic" },  -- if, else in corsivo
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            
            -- Colori personalizzati (opzionale)
            custom_highlights = {},
            
            -- Sfondo trasparente (se usi un terminale con trasparenza)
            transparent_background = false,
            
            -- Mostra colori terminale
            term_colors = true,
        })
        
        -- Applica il tema
        vim.cmd.colorscheme("catppuccin")
    end,
}

-- ============================================================================
-- SHORTCUTS TEMA (già incluse di default)
-- ============================================================================
-- Nessuna shortcut specifica necessaria, il tema si applica automaticamente
-- ============================================================================
