-- ============================================================================
-- 代码格式化: stevearc/conform.nvim
-- ============================================================================
--
-- 功能说明:
--   • 使用 conform.nvim 统一管理代码格式化
--   • 支持按文件类型自动选择 formatter
--   • 支持保存文件时自动格式化
--   • 支持 LSP fallback，当没有外部 formatter 时回退到 LSP 格式化
--
-- 配置效果:
--   ├─ Lua: stylua
--   ├─ Shell: shfmt
--   ├─ Go: goimports / gofumpt
--   ├─ Rust: rustfmt
--   ├─ C / C++: clang-format
--   ├─ Java: google-java-format
--   ├─ Kotlin: ktlint
--   ├─ Python: ruff_organize_imports / ruff_format
--   └─ Web / JSON / YAML / Markdown: prettier
--
-- Lazy.nvim 说明:
--   • mason-tool-installer.nvim 用于安装 formatter 工具
--   • conform.nvim 负责调用 formatter
--   • format_on_save 保存时自动格式化
--   • lsp_format = "fallback" 表示没有 formatter 时回退到 LSP 格式化
--

return {
	-- ========================================================================
	-- Formatter 工具自动安装
	-- ========================================================================

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		dependencies = {
			"mason-org/mason.nvim",
		},

		opts = {
			ensure_installed = {
				-- Lua
				"stylua",

				-- Shell
				"shfmt",

				-- Go
				"goimports",
				"gofumpt",

				-- C / C++
				"clang-format",

				-- Java
				"google-java-format",

				-- Kotlin
				"ktlint",

				-- Python
				"ruff",

				-- Web / JSON / YAML / Markdown
				"prettier",
			},

			-- 启动后异步检查缺失工具并安装
			run_on_start = true,

			-- 不自动更新已安装工具
			auto_update = false,

			-- 延迟启动，避免和 Neovim 首屏 / 首个文件加载抢资源
			start_delay = 8000,

			-- 24 小时内不重复检查
			debounce_hours = 24,
		},
	},

	-- ========================================================================
	-- 格式化主插件
	-- ========================================================================

	{
		"stevearc/conform.nvim",

		event = {
			"BufReadPre",
			"BufNewFile",
		},

		cmd = {
			"ConformInfo",
		},

		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({
						async = true,
						lsp_format = "fallback",
					})
				end,
				mode = {
					"n",
					"v",
				},
				desc = "格式化当前文件",
			},
		},

		opts = {
			-- ====================================================================
			-- 默认格式化行为
			-- ====================================================================

			default_format_opts = {
				-- fallback:
				--   优先使用 conform formatter
				--   没有 formatter 时使用 LSP 格式化
				lsp_format = "fallback",
			},

			-- ====================================================================
			-- Formatter 映射
			-- ====================================================================
			--
			-- 说明:
			--   • key 是 Neovim filetype
			--   • value 是 formatter 列表
			--   • formatter 会按顺序执行

			formatters_by_ft = {
				-- Lua / Neovim 配置
				lua = {
					"stylua",
				},

				-- Shell
				sh = {
					"shfmt",
				},

				bash = {
					"shfmt",
				},

				zsh = {
					"shfmt",
				},

				-- Go
				go = {
					"goimports",
					"gofumpt",
				},

				-- Rust
				-- rustfmt 通常由 rustup 提供，不通过 Mason 安装
				rust = {
					"rustfmt",
				},

				-- C / C++
				c = {
					"clang_format",
				},

				cpp = {
					"clang_format",
				},

				objc = {
					"clang_format",
				},

				objcpp = {
					"clang_format",
				},

				cuda = {
					"clang_format",
				},

				-- Java
				java = {
					"google_java_format",
				},

				-- Kotlin
				kotlin = {
					"ktlint",
				},

				-- Python
				python = {
					"ruff_organize_imports",
					"ruff_format",
				},

				-- Web
				html = {
					"prettier",
				},

				css = {
					"prettier",
				},

				scss = {
					"prettier",
				},

				javascript = {
					"prettier",
				},

				javascriptreact = {
					"prettier",
				},

				typescript = {
					"prettier",
				},

				typescriptreact = {
					"prettier",
				},

				-- 配置文件
				json = {
					"prettier",
				},

				jsonc = {
					"prettier",
				},

				yaml = {
					"prettier",
				},

				yml = {
					"prettier",
				},

				toml = {
					"taplo",
				},

				-- Markdown
				markdown = {
					"prettier",
				},
			},

			-- ====================================================================
			-- 保存时自动格式化
			-- ====================================================================

			format_on_save = function(bufnr)
				local filetype = vim.bo[bufnr].filetype

				-- 特殊文件类型禁用自动格式化
				-- 后续如果某类文件不想保存自动格式化，加到这里
				local disabled_filetypes = {
					-- markdown = true,
				}

				if disabled_filetypes[filetype] then
					return nil
				end

				return {
					timeout_ms = 3000,
					lsp_format = "fallback",
				}
			end,

			-- ====================================================================
			-- Formatter 细节配置
			-- ====================================================================

			formatters = {
				-- Shell:
				-- -i 4 表示缩进 4 个空格
				shfmt = {
					prepend_args = {
						"-i",
						"4",
					},
				},

				-- Web:
				-- 优先使用项目本地 node_modules/.bin/prettier
				prettier = {
					prefer_local = "node_modules/.bin",
				},

				-- C / C++:
				-- 默认会读取项目中的 .clang-format
				clang_format = {},

				-- Go:
				-- goimports 处理 import
				-- gofumpt 提供更严格的 gofmt 风格
				goimports = {},
				gofumpt = {},

				-- Python:
				-- ruff_organize_imports 负责 import 排序
				-- ruff_format 负责格式化
				ruff_organize_imports = {},
				ruff_format = {},

				-- Java
				google_java_format = {},

				-- Kotlin
				ktlint = {},

				-- Rust:
				-- rustfmt 通常来自 rustup component
				rustfmt = {},
			},
		},
	},
}
