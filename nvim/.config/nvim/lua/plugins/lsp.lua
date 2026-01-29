-- ============================================================================
-- lsp.lua - Configurazione Language Server Protocol (Neovim 0.11+)
-- ============================================================================
-- LSP fornisce:
-- - Autocompletamento intelligente
-- - Diagnostici (errori, warning)
-- - Go to definition
-- - Hover documentation
-- - Rename, format, code actions
-- 
-- NOTA: Usa la nuova API vim.lsp.config invece di lspconfig (deprecated)
-- ============================================================================

return {
	-- Mason: installer per LSP servers
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},

	-- Mason-lspconfig: bridge tra mason e lsp
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				-- LSP servers da installare automaticamente
				ensure_installed = {
					"clangd",        -- C/C++
					"pyright",       -- Python
					"lua_ls",        -- Lua
					"html",          -- HTML
					"cssls",         -- CSS
					"ts_ls",         -- JavaScript/TypeScript
					"bashls",        -- Bash
					"texlab",        -- LaTeX
					"marksman",      -- Markdown
				},

				-- Installa automaticamente server mancanti
				automatic_installation = true,
			})
		end,
	},

	-- LSP Config: configurazione dei server con nuova API
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",  -- Capabilities per autocompletamento
		},

		config = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			-- ============================================================
			-- KEYMAPS LSP
			-- ============================================================
			-- Keymaps applicati quando un LSP si attacca a un buffer
			local on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				local keymap = vim.keymap

				-- Informazioni
				keymap.set("n", "K", vim.lsp.buf.hover,
					vim.tbl_extend("force", opts, { desc = "Show hover information" }))

				keymap.set("n", "gd", vim.lsp.buf.definition,
					vim.tbl_extend("force", opts, { desc = "Go to definition" }))

				keymap.set("n", "gD", vim.lsp.buf.declaration,
					vim.tbl_extend("force", opts, { desc = "Go to declaration" }))

				keymap.set("n", "gi", vim.lsp.buf.implementation,
					vim.tbl_extend("force", opts, { desc = "Go to implementation" }))

				keymap.set("n", "gr", vim.lsp.buf.references,
					vim.tbl_extend("force", opts, { desc = "Show references" }))

				-- Diagnostici
				keymap.set("n", "<leader>d", vim.diagnostic.open_float,
					vim.tbl_extend("force", opts, { desc = "Show line diagnostics" }))

				keymap.set("n", "[d", vim.diagnostic.goto_prev,
					vim.tbl_extend("force", opts, { desc = "Go to previous diagnostic" }))

				keymap.set("n", "]d", vim.diagnostic.goto_next,
					vim.tbl_extend("force", opts, { desc = "Go to next diagnostic" }))

				-- Azioni
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts, { desc = "Show code actions" }))

				keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
					vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

				-- Formattazione
				keymap.set("n", "<leader>fm", function()
					vim.lsp.buf.format({ async = true })
				end, vim.tbl_extend("force", opts, { desc = "Format file" }))
			end

			-- ============================================================
			-- CAPABILITIES
			-- ============================================================
			-- Capabilities per supportare autocompletamento
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- ============================================================
			-- CONFIGURAZIONE SERVER CON NUOVA API vim.lsp.config
			-- ============================================================
			-- Neovim 0.11+ usa vim.lsp.config invece di lspconfig.X.setup()

			-- C/C++ (clangd)
			vim.lsp.config.clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
				},
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
				root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
				capabilities = capabilities,
			}

			-- Python (pyright)
			vim.lsp.config.pyright = {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			}

			-- Lua (lua_ls)
			vim.lsp.config.lua_ls = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },  -- Riconosce 'vim' globale
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}

			-- HTML
			vim.lsp.config.html = {
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html" },
				root_markers = { ".git" },
				capabilities = capabilities,
			}

			-- CSS
			vim.lsp.config.cssls = {
				cmd = { "vscode-css-language-server", "--stdio" },
				filetypes = { "css", "scss", "less" },
				root_markers = { ".git" },
				capabilities = capabilities,
			}

			-- JavaScript/TypeScript
			vim.lsp.config.ts_ls = {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
				root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
				capabilities = capabilities,
			}

			-- Bash
			vim.lsp.config.bashls = {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh", "bash" },
				root_markers = { ".git" },
				capabilities = capabilities,
			}

			-- LaTeX (texlab)
			vim.lsp.config.texlab = {
				cmd = { "texlab" },
				filetypes = { "tex", "plaintex", "bib" },
				root_markers = { ".latexmkrc", ".git" },
				capabilities = capabilities,
				settings = {
					texlab = {
						build = {
							executable = "latexmk",
							args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
							onSave = true,  -- Compila automaticamente al salvataggio
						},
						forwardSearch = {
							executable = "zathura",
							args = { "--synctex-forward", "%l:1:%f", "%p" },
						},
						chktex = {
							onOpenAndSave = true,
							onEdit = false,
						},
					},
				},
			}

			-- Markdown (marksman)
			vim.lsp.config.marksman = {
				cmd = { "marksman", "server" },
				filetypes = { "markdown", "markdown.mdx" },
				root_markers = { ".marksman.toml", ".git" },
				capabilities = capabilities,
			}

-- ============================================================
-- ABILITA I SERVER
-- ============================================================
-- Con la nuova API, i server vengono abilitati automaticamente
-- quando apri un file del tipo corretto. Tuttavia, possiamo
-- abilitarli esplicitamente per assicurarci che siano attivi.

			vim.lsp.enable("clangd")
			vim.lsp.enable("pyright")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("html")
			vim.lsp.enable("cssls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("bashls")
			vim.lsp.enable("texlab")
			vim.lsp.enable("marksman")

			-- ============================================================
			-- AUTOCMD PER ON_ATTACH
			-- ============================================================
			-- Con la nuova API, on_attach viene gestito tramite autocmd
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client then
						on_attach(client, ev.buf)
					end
				end,
			})

			-- ============================================================
			-- UI DIAGNOSTICI
			-- ============================================================
			-- Configurazione aspetto diagnostici
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",  -- Simbolo prima del messaggio
				},
				signs = true,      -- Mostra segni nella colonna
				underline = true,  -- Sottolinea errori
				update_in_insert = false,  -- Non aggiornare in insert mode
				severity_sort = true,      -- Ordina per gravità
			})

			-- Simboli per i segni nella colonna
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end,
	},

	-- Autocompletamento
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",     -- LSP source
			"hrsh7th/cmp-buffer",       -- Buffer source
			"hrsh7th/cmp-path",         -- Path source
			"L3MON4D3/LuaSnip",         -- Snippet engine
			"saadparwaiz1/cmp_luasnip", -- Snippet source
			"rafamadriz/friendly-snippets", -- Snippet collection
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Carica snippet predefiniti
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(),  -- Precedente
					["<C-j>"] = cmp.mapping.select_next_item(),  -- Successivo
					["<C-b>"] = cmp.mapping.scroll_docs(-4),     -- Scroll su
					["<C-f>"] = cmp.mapping.scroll_docs(4),      -- Scroll giù
					["<C-Space>"] = cmp.mapping.complete(),      -- Mostra suggerimenti
					["<C-e>"] = cmp.mapping.abort(),             -- Chiudi
					["<CR>"] = cmp.mapping.confirm({ select = false }), -- Conferma
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },  -- LSP
					{ name = "luasnip" },   -- Snippets
					{ name = "buffer" },    -- Buffer corrente
					{ name = "path" },      -- Filesystem paths
				}),
			})
		end,
	},
}

-- ============================================================================
-- NOTE INSTALLAZIONE
-- ============================================================================
-- LSP servers vengono installati automaticamente da Mason
-- 
-- IMPORTANTE: Questa configurazione usa la NUOVA API vim.lsp.config
-- introdotta in Neovim 0.11+ che sostituisce require('lspconfig').X.setup()
-- 
-- Comandi utili:
-- :Mason              - Apri interfaccia Mason
-- :MasonInstall X     - Installa server X
-- :MasonUninstall X   - Disinstalla server X
-- :LspInfo            - Info sui server attivi
-- :LspLog             - Vedi log LSP
-- 
-- DIPENDENZE ESTERNE NECESSARIE:
-- 
-- C/C++ (clangd):
--   Ubuntu/Debian: sudo apt install clangd
--   macOS: brew install llvm
--   Arch: sudo pacman -S clang
-- 
-- Python (pyright):
--   pip install pyright (o npm install -g pyright)
-- 
-- LaTeX (texlab):
--   Installato via Mason, ma richiede LaTeX distribution:
--   Ubuntu/Debian: sudo apt install texlive-full
--   macOS: brew install --cask mactex
--   Arch: sudo pacman -S texlive-most
-- 
-- ============================================================================
