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
						indent = 2,
						padding = 1,
					},
					{
						pane = 2,
						icon = " ",
						title = "Projects",
						section = "projects",
						indent = 2,
						padding = 1,
					},
					{
						section = "startup",
						padding = 2,
					},
				},
			},
			input = {
				enabled = true,
				icon = "󰥻 ",
				icon_pos = "left",
				prompt_pos = "title",
			},
			notifier = {
				enabled = true,
				timeout = 2500,
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
						return vim.o.columns >= 140 and "default" or "vertical"
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
							min_width = 120,
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
							width = 0.58,
							min_width = 84,
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
								height = 0.42,
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
					row = 4,
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
					width = 0.6,
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
