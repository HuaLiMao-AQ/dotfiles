-- ============================================================================
-- Buffer 标签栏美化: akinsho/bufferline.nvim
-- ============================================================================
--
-- 功能说明:
--   • 在编辑器顶部显示打开的 buffer 标签栏
--   • 支持斜线风格分隔符，美观简洁
--   • 显示 LSP 诊断信息（错误/警告/信息/提示数量）
--   • 快捷键: Shift+h 上一个 buffer, Shift+l 下一个 buffer
--
-- 配置效果:
--   ├─ 美化: 现代的标签栏设计，斜线分隔符视觉效果好
--   ├─ 诊断: 直观显示各 buffer 的错误/警告状态
--   └─ 导航: 快速在多个 buffer 之间切换
--
-- Lazy.nvim 说明:
--   • dependencies 用于声明 mini.icons 图标依赖
--   • event = "VeryLazy" 表示启动后延迟加载，减少启动压力
--   • keys 会在按下快捷键时自动加载插件
--

return {
	{
		"akinsho/bufferline.nvim",

		-- 启动后延迟加载
		event = "VeryLazy",

		-- 图标依赖
		dependencies = {
			"nvim-mini/mini.icons",
		},

		-- 快捷键配置
		keys = {
			{
				"<S-l>",
				"<Cmd>BufferLineCycleNext<CR>",
				mode = "n",
				desc = "Next buffer",
			},
			{
				"<S-h>",
				"<Cmd>BufferLineCyclePrev<CR>",
				mode = "n",
				desc = "Previous buffer",
			},
		},

		opts = {
			options = {
				mode = "buffers", -- 显示 buffer 而不是 tab
				separator_style = "thin", -- 斜线分隔符
				always_show_bufferline = false, -- 始终显示标签栏

				show_buffer_close_icons = false, -- 隐藏 buffer 关闭按钮
				show_close_icon = false, -- 隐藏右侧关闭按钮

				diagnostics = "nvim_lsp", -- 显示 LSP 诊断信息

				-- 自定义诊断显示格式：
				-- 例如 E2 W1 表示 2 个错误、1 个警告
				diagnostics_indicator = function(_, _, diag)
					local icons = {
						Error = "E",
						Warn = "W",
						Info = "I",
						Hint = "H",
					}

					local result = {}

					for level, count in pairs(diag) do
						if icons[level] and count > 0 then
							table.insert(result, string.format("%s%d", icons[level], count))
						end
					end

					return table.concat(result, " ")
				end,
			},

			highlights = {
				fill = {
					bg = "NONE",
				},
				background = {
					bg = "NONE",
				},
				buffer_visible = {
					bg = "NONE",
				},
				buffer_selected = {
					bg = "NONE",
					bold = true,
					italic = true,
				},
				separator = {
					bg = "NONE",
				},
				separator_visible = {
					bg = "NONE",
				},
				separator_selected = {
					bg = "NONE",
				},
				indicator_selected = {
					bg = "#1a1b26",
				},
				modified = {
					bg = "NONE",
				},
				modified_visible = {
					bg = "NONE",
				},
				modified_selected = {
					bg = "NONE",
				},
				close_button = {
					fg = "#565f89",
					bg = "NONE",
				},
				close_button_visible = {
					bg = "NONE",
				},
				close_button_selected = {
					bg = "NONE",
				},
			},
		},
	},
}
