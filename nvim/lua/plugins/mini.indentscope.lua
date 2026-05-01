-- ============================================================================
-- Mini.indentscope 当前代码块范围高亮
-- ============================================================================
-- 功能说明:
--   mini.indentscope 用于显示当前光标所在代码块的缩进范围。
--   它会在当前 scope 内绘制一条竖线，帮助判断 if / for / function
--   等代码块的起止范围。
--
-- 配置效果:
--   1. 高亮当前缩进代码块范围
--   2. 使用竖线显示当前 scope
--   3. 关闭动画，避免视觉干扰
--   4. 排除 neo-tree / lazy / mason 等特殊窗口
-- ============================================================================

return {
	"nvim-mini/mini.indentscope",
	version = false,

	event = { "BufReadPost", "BufNewFile" },

	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"dashboard",
				"snacks_dashboard",
				"lazy",
				"lazy_backdrop",
				"mason",
				"mason_backdrop",
				"neo-tree",
				"neo-tree-popup",
				"NvimTree",
				"Trouble",
				"trouble",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,

	config = function()
		require("mini.indentscope").setup({
			symbol = "│",

			options = {
				try_as_border = true,
			},

			draw = {
				animation = require("mini.indentscope").gen_animation.none(),
			},
		})
	end,
}
