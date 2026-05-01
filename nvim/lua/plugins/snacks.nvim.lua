-- ============================================================================
-- UI 工具集合: folke/snacks.nvim
-- ============================================================================
--
-- 功能说明:
--   • 提供 dashboard、picker、input、notifier、quickfile、lazygit、scratch 等常用 UI 能力
--   • 使用 Snacks picker 替代 Telescope 类搜索入口，统一文件、文本、命令、帮助等查找体验
--   • 使用 Snacks input / notifier 统一输入框和通知样式
--   • 使用 quickfile 减少打开文件时的额外等待
--   • 提供 LazyGit 浮窗和 scratch 临时草稿能力
--
-- 配置效果:
--   ├─ Dashboard: 启动页展示常用操作、最近文件、项目入口和启动耗时
--   ├─ Picker: 文件 / 文本 / Buffer / 历史 / 命令 / 快捷键 / 帮助统一搜索
--   ├─ Input: 使用紧凑浮窗输入框，和 Noice / 主题高亮保持一致
--   ├─ Notifier: 使用 Snacks 通知后端，减少默认通知干扰
--   ├─ LazyGit: 通过浮动终端打开 lazygit，并在缺少可执行文件时给出提示
--   └─ Scratch: 快速打开和选择持久化草稿 buffer
--
-- 快捷键:
--   • <leader>ff: 搜索文件
--   • <leader>fg: 搜索文本
--   • <leader>fb: 搜索 Buffer
--   • <leader>fo: 搜索历史文件
--   • <leader>fc: 搜索命令
--   • <leader>fk: 搜索快捷键
--   • <leader>fh: 搜索帮助文档
--   • <leader>fr: 恢复上一次搜索
--   • <leader>gg: 打开 LazyGit
--   • <leader>.: 打开草稿
--   • <leader>S: 选择草稿
--
-- Lazy.nvim 说明:
--   • lazy = false 表示启动时加载，保证 dashboard / input / notifier 早期可用
--   • priority = 1000 保证 UI 基础能力优先加载
--   • opts 会自动传给 require("snacks").setup(...)
--

local function pick(method, opts)
	return function()
		Snacks.picker[method](opts)
	end
end

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		keys = {
			{
				"<leader>ff",
				pick("files"),
				desc = "搜索文件",
			},
			{
				"<leader>fg",
				pick("grep"),
				desc = "搜索文本",
			},
			{
				"<leader>fb",
				pick("buffers"),
				desc = "搜索 Buffer",
			},
			{
				"<leader>fo",
				pick("recent"),
				desc = "搜索历史文件",
			},
			{
				"<leader>fc",
				pick("commands"),
				desc = "搜索命令",
			},
			{
				"<leader>fk",
				pick("keymaps"),
				desc = "搜索快捷键",
			},
			{
				"<leader>fh",
				pick("help"),
				desc = "搜索帮助文档",
			},
			{
				"<leader>fr",
				pick("resume"),
				desc = "恢复上一次搜索",
			},
			{
				"<leader>gg",
				function()
					if vim.fn.executable("lazygit") ~= 1 then
						Snacks.notify.warn("未找到 lazygit，请先安装 lazygit 后再使用。", {
							title = "LazyGit",
						})
						return
					end

					Snacks.lazygit.open()
				end,
				desc = "LazyGit",
			},
			{
				"<leader>.",
				function()
					Snacks.scratch.open()
				end,
				desc = "打开草稿",
			},
			{
				"<leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "选择草稿",
			},
		},
		opts = {
			dashboard = {
				enabled = true,
				width = 84,
				row = nil,
				col = nil,
				pane_gap = 4,
				preset = {
					header = [[
    ███╗   ██╗██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██║   ██║██║████╗ ████║
    ██╔██╗ ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝

          Dotfiles Development Environment
                    ]],
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find file",
							action = pick("files"),
						},
						{
							icon = " ",
							key = "g",
							desc = "Live grep",
							action = pick("grep"),
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent files",
							action = pick("recent"),
						},
						{
							icon = " ",
							key = "c",
							desc = "Edit config",
							action = pick("files", { cwd = vim.fn.stdpath("config") }),
						},
						{
							icon = "󰒲 ",
							key = "l",
							desc = "Lazy plugins",
							action = function()
								vim.cmd("Lazy")
							end,
							enabled = package.loaded.lazy ~= nil,
						},
						{
							icon = "󱥚 ",
							key = "m",
							desc = "Mason tools",
							action = function()
								vim.cmd("Mason")
							end,
						},
						{
							icon = " ",
							key = "q",
							desc = "Quit",
							action = function()
								vim.cmd("qa")
							end,
						},
					},
				},
				sections = {
					{
						section = "header",
						padding = 1,
					},
					{
						pane = 1,
						icon = " ",
						title = "Actions",
						section = "keys",
						gap = 0,
						padding = 1,
					},
					{
						pane = 2,
						icon = " ",
						title = "Recent Files",
						section = "recent_files",
						limit = 6,
						indent = 2,
						padding = 1,
					},
					{
						pane = 2,
						icon = " ",
						title = "Projects",
						section = "projects",
						limit = 4,
						indent = 2,
						padding = 1,
					},
					{
						section = "startup",
						padding = 2,
					},
				},
			},
			quickfile = {
				enabled = true,
			},
			lazygit = {
				enabled = true,
				configure = true,
			},
			scratch = {
				enabled = true,
			},
			input = {
				enabled = true,
				icon = "󰥻 ",
				icon_pos = "left",
				prompt_pos = "title",
			},
			notifier = {
				enabled = true,
				timeout = 2200,
				style = "compact",
				top_down = true,
				margin = {
					top = 1,
					right = 1,
					bottom = 0,
				},
			},
			picker = {
				enabled = true,
				ui_select = true,
				focus = "input",
				layout = {
					preset = function()
						return vim.o.columns >= 128 and "default" or "vertical"
					end,
				},
				formatters = {
					file = {
						filename_first = true,
						truncate = "center",
					},
				},
				sources = {
					files = {
						hidden = true,
						follow = true,
						ignored = false,
						exclude = {
							".git",
						},
					},
					grep = {
						hidden = true,
						follow = true,
						ignored = false,
						exclude = {
							".git",
						},
					},
				},
				layouts = {
					default = {
						layout = {
							box = "horizontal",
							backdrop = false,
							width = 0.86,
							min_width = 104,
							height = 0.82,
							{
								box = "vertical",
								border = true,
								title = "{title} {live} {flags}",
								title_pos = "center",
								{
									win = "input",
									height = 1,
									border = "bottom",
								},
								{
									win = "list",
									border = "none",
								},
							},
							{
								win = "preview",
								title = "{preview}",
								title_pos = "center",
								border = true,
								width = 0.52,
							},
						},
					},
					vertical = {
						layout = {
							backdrop = false,
							width = 0.72,
							min_width = 76,
							height = 0.82,
							min_height = 28,
							box = "vertical",
							border = true,
							title = "{title} {live} {flags}",
							title_pos = "center",
							{
								win = "input",
								height = 1,
								border = "bottom",
							},
							{
								win = "list",
								border = "none",
							},
							{
								win = "preview",
								title = "{preview}",
								title_pos = "center",
								height = 0.38,
								border = "top",
							},
						},
					},
					vscode = {
						hidden = {
							"preview",
						},
						layout = {
							backdrop = false,
							row = 1,
							width = 0.46,
							min_width = 82,
							height = 0.42,
							border = "none",
							box = "vertical",
							{
								win = "input",
								height = 1,
								border = true,
								title = "{title} {live} {flags}",
								title_pos = "center",
							},
							{
								win = "list",
								border = "hpad",
							},
							{
								win = "preview",
								title = "{preview}",
								border = true,
							},
						},
					},
					select = {
						hidden = {
							"preview",
						},
						layout = {
							backdrop = false,
							width = 0.48,
							min_width = 60,
							max_width = 90,
							height = 0.36,
							min_height = 3,
							box = "vertical",
							border = true,
							title = "{title}",
							title_pos = "center",
							{
								win = "input",
								height = 1,
								border = "bottom",
							},
							{
								win = "list",
								border = "none",
							},
						},
					},
				},
				win = {
					input = {
						wo = {
							winhighlight = "NormalFloat:NormalFloat,FloatBorder:SnacksPickerInputBorder,FloatTitle:SnacksPickerInputTitle",
						},
					},
					list = {
						wo = {
							winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,FloatTitle:SnacksPickerBoxTitle,CursorLine:Visual,Search:None",
						},
					},
					preview = {
						wo = {
							winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,FloatTitle:FloatTitle",
						},
					},
				},
			},
			styles = {
				dashboard = {
					wo = {
						winhighlight = "Normal:SnacksDashboardNormal,NormalFloat:SnacksDashboardNormal",
					},
				},
				input = {
					backdrop = false,
					border = "rounded",
					title_pos = "center",
					width = 58,
					row = 5,
					wo = {
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
					},
				},
				notification = {
					border = "rounded",
					zindex = 100,
					ft = "markdown",
					wo = {
						winblend = 0,
						wrap = false,
						conceallevel = 2,
						colorcolumn = "",
					},
				},
				notification_history = {
					border = "rounded",
					zindex = 100,
					width = 0.52,
					height = 0.6,
					minimal = false,
					title = " Notification History ",
					title_pos = "center",
					ft = "markdown",
					bo = {
						filetype = "snacks_notif_history",
						modifiable = false,
					},
					wo = {
						winhighlight = "Normal:SnacksNotifierHistory,FloatBorder:FloatBorder,FloatTitle:FloatTitle",
					},
					keys = {
						q = "close",
					},
				},
			},
		},
	},
}
