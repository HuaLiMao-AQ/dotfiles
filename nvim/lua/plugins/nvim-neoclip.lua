-- ============================================================================
-- 剪贴板历史: AckslD/nvim-neoclip.lua
-- ============================================================================
--
-- 功能说明:
--   • 记录当前 Neovim 会话中的 yank 历史
--   • 支持通过 Telescope 选择历史内容并写回寄存器
--   • 支持宏录制历史，方便重复调用常用宏
--   • 自动去重相同 yank 内容，保持历史列表可读
--
-- 配置效果:
--   ├─ <leader>fy: 搜索 yank 历史
--   ├─ <leader>fY: 搜索宏历史
--   ├─ Enter: 将选中内容写入默认寄存器
--   ├─ p / P: 直接粘贴选中内容
--   └─ d: 删除选中的历史项
--
-- 注意:
--   • nvim-neoclip.lua 需要 Telescope 或 fzf-lua 作为选择器后端
--   • 这里只把 Telescope 作为 neoclip 的局部依赖，不替换现有 Snacks picker
--   • 默认不启用持久化历史，避免额外引入 sqlite 依赖
--
-- Lazy.nvim 说明:
--   • event = "VeryLazy" 表示启动完成后开始记录 yank
--   • keys 表示按下剪贴板历史快捷键时打开 Telescope 扩展
--   • dependencies 声明 neoclip 的选择器和 Telescope 所需依赖
--

return {
	{
		"AckslD/nvim-neoclip.lua",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>fy",
				function()
					require("telescope").extensions.neoclip.default()
				end,
				desc = "搜索剪贴板历史",
			},
			{
				"<leader>fY",
				function()
					require("telescope").extensions.macroscope.default()
				end,
				desc = "搜索宏历史",
			},
		},
		opts = {
			history = 1000,
			enable_persistent_history = false,
			enable_macro_history = true,
			continuous_sync = false,
			default_register = '"',
			filter = nil,
			preview = true,
			prompt = "Clipboard History",
		},
		config = function(_, opts)
			require("neoclip").setup(opts)
			require("telescope").load_extension("neoclip")
			require("telescope").load_extension("macroscope")
		end,
	},
}
