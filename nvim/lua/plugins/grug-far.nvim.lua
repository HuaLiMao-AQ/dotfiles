-- ============================================================================
-- 项目搜索替换: MagicDuck/grug-far.nvim
-- ============================================================================
--
-- 功能说明:
--   • 提供交互式全项目搜索与替换
--   • 适合批量重命名文本、迁移配置项、处理跨文件替换
--   • 支持用当前光标下单词预填搜索词
--
-- 配置效果:
--   ├─ <leader>sr: 打开搜索替换界面
--   └─ <leader>sR: 打开搜索替换界面并预填当前词
--
-- Lazy.nvim 说明:
--   • cmd = "GrugFar" 表示执行命令时加载
--   • keys 表示按下搜索替换快捷键时加载
--   • opts = {} 使用插件默认配置，减少额外维护成本
--

return {
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				"<cmd>GrugFar<cr>",
				desc = "搜索替换",
			},
			{
				"<leader>sR",
				function()
					local grug = require("grug-far")

					grug.open({
						prefills = {
							search = vim.fn.expand("<cword>"),
						},
					})
				end,
				desc = "搜索替换当前词",
			},
		},
		opts = {},
	},
}
