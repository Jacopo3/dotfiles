return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
}

-- ============================================================================
-- NOTE INSTALLAZIONE
-- ============================================================================
-- Tree-sitter richiede un compilatore C:
-- 
-- Ubuntu/Debian:
--   sudo apt install build-essential
-- 
-- macOS:
--   xcode-select --install
-- 
-- Arch:
--   sudo pacman -S base-devel
-- 
-- Windows:
--   Installa MinGW o MSVC
-- ============================================================================

-- ============================================================================
-- COMANDI UTILI
-- ============================================================================
-- :TSInstall <language>    - Installa parser per un linguaggio
-- :TSUpdate               - Aggiorna tutti i parser
-- :TSUninstall <language> - Disinstalla parser
-- :TSInstallInfo          - Mostra stato installazione parser
-- ============================================================================
