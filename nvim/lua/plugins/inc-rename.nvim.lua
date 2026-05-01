-- ============================================================================
-- 增量重命名预览: smjonas/inc-rename.nvim
-- ============================================================================
--
-- 功能说明:
--   • 增强 LSP rename，输入新名称时实时预览引用位置变化
--   • 通过 Noice 的 inc_rename 预设显示输入框，避免出现两套输入 UI
--   • 使用当前光标下单词预填新名称，提高重命名效率
--
-- 配置效果:
--   ├─ <leader>rn: 打开 IncRename，并预填当前词
--   ├─ 实时预览: 输入过程中显示即将修改的引用位置
--   └─ UI: 只使用 Noice / IncRename 自身输入框，不使用 Snacks input
--
-- 注意:
--   • 不设置 input_buffer_type = "snacks"
--   • 如果启用 Snacks input，会和 IncRename 命令行预览同时出现两个输入框
--
-- Lazy.nvim 说明:
--   • cmd = "IncRename" 表示执行命令时加载
--   • keys 表示按下 <leader>rn 时加载
--   • opts = {} 使用默认配置，UI 集成由 noice.nvim 的 preset 负责
--

return {
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		keys = {
			{
				"<leader>rn",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				expr = true,
				desc = "重命名",
			},
		},
		opts = {},
	},
}
