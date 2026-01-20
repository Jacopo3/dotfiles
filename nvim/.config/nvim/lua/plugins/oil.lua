-- ============================================================================
-- oil.lua - Configurazione Oil.nvim (file manager)
-- ============================================================================
-- Oil trasforma il file browser in un buffer editabile
-- Puoi modificare file/cartelle come se fosse testo normale
-- ============================================================================

return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    
    config = function()
        require("oil").setup({
            -- Colonne da mostrare
            columns = {
                "icon",      -- Icona del tipo di file
                "permissions", -- Permessi (rwx)
                "size",      -- Dimensione file
                "mtime",     -- Data ultima modifica
            },
            
            -- Buffer oil si comporta come buffer normale
            buf_options = {
                buflisted = false,
                bufhidden = "hide",
            },
            
            -- Mostra file nascosti di default
            view_options = {
                show_hidden = true,  -- Mostra file che iniziano con .
                is_hidden_file = function(name, bufnr)
                    -- Nascondi .git directory
                    return vim.startswith(name, ".git")
                end,
                is_always_hidden = function(name, bufnr)
                    return false
                end,
            },
            
            -- Azioni personalizzate
            keymaps = {
                ["g?"] = "actions.show_help",      -- Mostra help
                ["<CR>"] = "actions.select",       -- Apri file/cartella
                ["<C-v>"] = "actions.select_vsplit", -- Apri in split verticale
                ["<C-h>"] = "actions.select_split",  -- Apri in split orizzontale
                ["<C-t>"] = "actions.select_tab",    -- Apri in nuovo tab
                ["<C-p>"] = "actions.preview",       -- Anteprima file
                ["<C-c>"] = "actions.close",         -- Chiudi oil
                ["<C-r>"] = "actions.refresh",       -- Ricarica directory
                ["-"] = "actions.parent",            -- Vai alla directory padre
                ["_"] = "actions.open_cwd",          -- Apri directory corrente
                ["`"] = "actions.cd",                -- Cambia directory
                ["~"] = "actions.tcd",               -- Cambia directory per tab
                ["gs"] = "actions.change_sort",      -- Cambia ordinamento
                ["gx"] = "actions.open_external",    -- Apri con app esterna
                ["g."] = "actions.toggle_hidden",    -- Mostra/nascondi file nascosti
            },
            
            -- Usa trash invece di cancellazione permanente
            delete_to_trash = true,
            
            -- Conferma prima di cancellare/sovrascrivere
            skip_confirm_for_simple_edits = false,
            
            -- Prompt di conferma
            prompt_save_on_select_new_entry = true,
        })
        
        -- ====================================================================
        -- KEYMAPS OIL
        -- ====================================================================
        local keymap = vim.keymap
        
        -- Apri oil nella directory del file corrente
        keymap.set("n", "<leader>e", "<cmd>Oil<CR>", 
            { desc = "Open file explorer (Oil)" })
        
        -- Apri oil nella directory corrente di lavoro
        keymap.set("n", "<leader>E", function()
            require("oil").open(vim.loop.cwd())
        end, { desc = "Open file explorer in cwd (Oil)" })
        
        -- Apri oil in una finestra floating
        keymap.set("n", "<leader>-", function()
            require("oil").open_float()
        end, { desc = "Open file explorer in floating window (Oil)" })
    end,
}

-- ============================================================================
-- COME USARE OIL
-- ============================================================================
-- 1. Apri oil con <leader>e
-- 2. Naviga con j/k
-- 3. Apri file/cartelle con Enter
-- 4. MODIFICA come testo normale:
--    - Rinomina: modifica il nome del file
--    - Cancella: cancella la riga (dd)
--    - Crea: aggiungi una nuova riga con il nome
--    - Sposta: taglia e incolla
-- 5. Salva le modifiche con :w
-- 6. Annulla con :q! (senza salvare)
-- ============================================================================
