-- ============================================================================
-- keymaps.lua - Scorciatoie da tastiera generali
-- ============================================================================
-- Definisce le shortcuts che non dipendono da plugin specifici
-- Convenzioni:
--   <leader> = SPAZIO
--   <C-x> = Ctrl+x
--   <A-x> = Alt+x
-- ============================================================================

local keymap = vim.keymap

-- Funzione helper per impostare keymaps con opzioni default
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	keymap.set(mode, lhs, rhs, opts)
end

-- ============================================================================
-- NAVIGAZIONE GENERALE
-- ============================================================================

-- Cancella evidenziazione ricerca con <leader>nh
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Navigazione tra finestre
map("n", "<C-Left>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-Down>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-Up>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-Right>", "<C-w>l", { desc = "Move to right window" })

-- ============================================================================
-- GESTIONE FINESTRE
-- ============================================================================

-- Split verticale
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })

-- Split orizzontale
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })

-- Uguaglia dimensioni finestre
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })

-- Chiudi finestra corrente
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- ============================================================================
-- GESTIONE TAB
-- ============================================================================

-- Nuovo tab
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })

-- Chiudi tab corrente
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })

-- Prossimo tab
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })

-- Tab precedente
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

-- ============================================================================
-- GESTIONE BUFFER
-- ============================================================================

-- Prossimo buffer
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Go to next buffer" })

-- Buffer precedente
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" })

-- Chiudi buffer corrente
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete current buffer" })

-- ============================================================================
-- EDITING
-- ============================================================================

-- Indenta in visual mode e mantieni selezione
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Sposta righe selezionate su/giù in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Mantieni il cursore al centro quando scorri
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Mantieni il cursore al centro durante la ricerca
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- ============================================================================
-- SALVATAGGIO RAPIDO
-- ============================================================================

-- Salva file con <leader>w
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Salva ed esci con <leader>q
map("n", "<leader>q", "<cmd>wq<CR>", { desc = "Save and quit" })

-- Esci senza salvare con <leader>Q
map("n", "<leader>Q", "<cmd>q!<CR>", { desc = "Quit without saving" })
