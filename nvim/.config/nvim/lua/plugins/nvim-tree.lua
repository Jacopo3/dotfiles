-- ============================================================================
-- nvim-tree.lua - File Explorer ad Albero Laterale
-- ============================================================================
-- Nvim-tree fornisce un file explorer tradizionale simile a VSCode
-- con visualizzazione ad albero sulla sinistra dello schermo
-- ============================================================================

return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",  -- Icone per i file
    },
    
    config = function()
        -- Disabilita netrw (file explorer di vim nativo)
        -- Necessario per evitare conflitti con nvim-tree
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        
        -- ================================================================
        -- CONFIGURAZIONE NVIM-TREE
        -- ================================================================
        
        require("nvim-tree").setup({
            -- ============================================================
            -- RENDERING
            -- ============================================================
            renderer = {
                -- Icone per cartelle e file
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                    glyphs = {
                        default = "",
                        symlink = "",
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "✗",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    },
                },
                -- Evidenzia file aperti
                highlight_opened_files = "name",
                -- Indentazione
                indent_markers = {
                    enable = true,
                    icons = {
                        corner = "└",
                        edge = "│",
                        item = "│",
                        none = " ",
                    },
                },
            },
            
            -- ============================================================
            -- VISTA
            -- ============================================================
            view = {
                -- Larghezza del tree
                width = 35,
                -- Posizione (left o right)
                side = "left",
                -- Preserva larghezza quando apri file
                preserve_window_proportions = true,
                -- Numero di riga relativo
                number = false,
                relativenumber = false,
            },
            
            -- ============================================================
            -- AZIONI
            -- ============================================================
            actions = {
                -- Quando apri un file
                open_file = {
                    -- Non chiudere tree quando apri file
                    quit_on_open = false,
                    -- Ridimensiona finestre quando apri file
                    resize_window = true,
                    -- Finestra da usare per aprire file
                    window_picker = {
                        enable = true,
                        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                        exclude = {
                            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                            buftype = { "nofile", "terminal", "help" },
                        },
                    },
                },
            },
            
            -- ============================================================
            -- FILTRI
            -- ============================================================
            filters = {
                -- File/cartelle da nascondere
                dotfiles = false,  -- Mostra file che iniziano con .
                custom = {
                    ".git",
                    "node_modules",
                    ".cache",
                },
                -- Escludi file
                exclude = {},
            },
            
            -- ============================================================
            -- GIT
            -- ============================================================
            git = {
                enable = true,
                ignore = false,  -- Mostra anche file ignorati da git
                timeout = 400,
            },
            
            -- ============================================================
            -- FILE SYSTEM WATCHERS
            -- ============================================================
            filesystem_watchers = {
                enable = true,
                debounce_delay = 50,
            },
            
            -- ============================================================
            -- DIAGNOSTICI LSP
            -- ============================================================
            diagnostics = {
                enable = true,
                show_on_dirs = true,
                icons = {
                    hint = "",
                    info = "",
                    warning = "",
                    error = "",
                },
            },
            
            -- ============================================================
            -- MODIFICHE
            -- ============================================================
            modified = {
                enable = true,
                show_on_dirs = true,
            },
            
            -- ============================================================
            -- AGGIORNA DIRECTORY CORRENTE
            -- ============================================================
            update_focused_file = {
                enable = true,  -- Sincronizza tree con file corrente
                update_root = false,  -- Non cambiare root automaticamente
                ignore_list = {},
            },
            
            -- ============================================================
            -- COMPORTAMENTO TAB
            -- ============================================================
            tab = {
                sync = {
                    open = true,   -- Apri tree in nuovi tab
                    close = true,  -- Chiudi tree quando chiudi tab
                },
            },
        })
        
        -- ================================================================
        -- KEYMAPS NVIM-TREE
        -- ================================================================
        
        local keymap = vim.keymap
        
        -- Toggle nvim-tree (apri/chiudi)
        keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>", 
            { desc = "Toggle file tree" })
        
        -- Focus su nvim-tree (se già aperto)
        keymap.set("n", "<leader>tf", "<cmd>NvimTreeFocus<CR>", 
            { desc = "Focus on file tree" })
        
        -- Trova file corrente nel tree
        keymap.set("n", "<leader>tc", "<cmd>NvimTreeFindFile<CR>", 
            { desc = "Find current file in tree" })
        
        -- Chiudi nvim-tree
        keymap.set("n", "<leader>tq", "<cmd>NvimTreeClose<CR>", 
            { desc = "Close file tree" })
        
        -- Refresh nvim-tree
        keymap.set("n", "<leader>tr", "<cmd>NvimTreeRefresh<CR>", 
            { desc = "Refresh file tree" })
    end,
}

-- ============================================================================
-- KEYMAPS ALL'INTERNO DI NVIM-TREE
-- ============================================================================
-- Quando sei dentro nvim-tree, puoi usare:
--
-- NAVIGAZIONE:
--   <CR>         - Apri file/cartella
--   o            - Apri file/cartella (stesso di Enter)
--   <C-v>        - Apri in split verticale
--   <C-x>        - Apri in split orizzontale
--   <C-t>        - Apri in nuovo tab
--   <Tab>        - Apri in preview (senza spostare focus)
--   P            - Vai al nodo parent (cartella superiore)
--   <BS>         - Chiudi cartella
--   K            - Vai al primo nodo
--   J            - Vai all'ultimo nodo
--
-- FILE OPERATIONS:
--   a            - Crea nuovo file/cartella (termina con / per cartella)
--   d            - Cancella file/cartella
--   r            - Rinomina file/cartella
--   x            - Taglia file/cartella
--   c            - Copia file/cartella
--   p            - Incolla file/cartella
--   y            - Copia nome file
--   Y            - Copia percorso relativo
--   gy           - Copia percorso assoluto
--
-- VISTA:
--   R            - Refresh tree
--   H            - Toggle file nascosti
--   I            - Toggle file ignorati da git
--   .            - Cambia root directory al nodo corrente
--   -            - Vai alla directory parent come root
--   W            - Collassa tutto
--   E            - Espandi tutto
--
-- INFO:
--   g?           - Mostra help con tutti i comandi
--   q            - Chiudi nvim-tree
-- ============================================================================

-- ============================================================================
-- CONFRONTO CON OIL
-- ============================================================================
-- Hai ora DUE file explorers:
--
-- NVIM-TREE (<leader>t):
--   - Visualizzazione ad albero tradizionale
--   - Sempre visibile lateralmente
--   - Perfetto per navigare progetti grandi
--   - Operazioni con shortcuts dedicate
--
-- OIL (<leader>e):
--   - Editing diretto come buffer di testo
--   - Apre nella finestra corrente
--   - Perfetto per operazioni batch su file
--   - Usa comandi vim normali (dd, yy, pp)
--
-- Usa quello che preferisci in base alla situazione!
-- ============================================================================
