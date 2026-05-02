-- ============================================================================
-- andymass/vim-matchup 结构匹配高亮
-- ============================================================================
-- 功能说明:
--   vim-matchup 是增强版匹配插件，可替代默认 matchparen。
--   除了普通括号外，还支持 if/end、for/end、HTML 标签等结构匹配。
--
-- 配置效果:
--   ├─ 高亮当前括号对
--   ├─ 支持语言级结构匹配
--   ├─ 支持 Treesitter 集成
--   └─ 更适合阅读 Lua / Vimscript / HTML / Markdown 等嵌套结构
-- ============================================================================

return {
	"andymass/vim-matchup",

	event = { "BufReadPost", "BufNewFile" },

	init = function()
		-- 禁用默认 matchparen，交给 vim-matchup 处理
		vim.g.loaded_matchparen = 1

		-- 启用 Treesitter 集成
		vim.g.matchup_matchparen_offscreen = { method = "popup" }
		vim.g.matchup_treesitter_enabled = 1
	end,
}
