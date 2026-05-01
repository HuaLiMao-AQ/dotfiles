-- ============================================================================
-- 快捷键提示: folke/which-key.nvim
-- ============================================================================
--
-- 功能说明:
--   • 在输入快捷键前缀时弹出可用按键提示
--   • 用于快速查看 leader 分组、插件快捷键和 buffer-local 快捷键
--   • 为常用快捷键前缀补充分组名称，降低记忆成本
--   • 支持手动查看当前 buffer 的可用快捷键
--
-- 配置效果:
--   ├─ <leader>?: 查看当前 buffer 快捷键
--   ├─ <leader>f: 搜索 / 查找
--   ├─ <leader>g: Git
--   ├─ <leader>h: Git hunk
--   ├─ <leader>R: REST 请求
--   ├─ <leader>r: 重构
--   ├─ <leader>s: 搜索替换
--   ├─ <leader>x: 诊断 / 列表
--   └─ <leader>c: 代码操作
--
-- Lazy.nvim 说明:
--   • event = "VeryLazy" 表示启动完成后加载
--   • keys 表示按下 <leader>? 时也可以触发加载
--   • opts 会自动传给 require("which-key").setup(...)
--

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({
						global = false,
					})
				end,
				desc = "查看当前快捷键",
			},
		},
		opts = {
			preset = "modern",
			delay = 500,
			icons = {
				mappings = true,
			},
			win = {
				border = "rounded",
			},
			spec = {
				{
					"<leader>f",
					group = "搜索",
				},
				{
					"<leader>g",
					group = "Git",
				},
				{
					"<leader>h",
					group = "Git Hunk",
				},
				{
					"<leader>R",
					group = "REST 请求",
				},
				{
					"<leader>r",
					group = "重构",
				},
				{
					"<leader>s",
					group = "搜索替换",
				},
				{
					"<leader>x",
					group = "诊断 / 列表",
				},
				{
					"<leader>c",
					group = "代码",
				},
			},
		},
	},
}
