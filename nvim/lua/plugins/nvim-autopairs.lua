-- ============================================================================
-- nvim-autopairs
-- ============================================================================
--
-- 功能说明:
--   自动补全成对符号，例如:
--     (  ->  ()
--     [  ->  []
--     {  ->  {}
--     "  ->  ""
--     '  ->  ''
--
-- 配置效果:
--   1. 输入左括号时自动补全右括号。
--   2. 输入 `{` 后回车，可以自动展开代码块。
--   3. 配合 nvim-cmp 时，函数补全后自动补全括号。
--   4. 对 TelescopePrompt 等特殊窗口禁用，避免干扰输入。
--   5. 开启 Treesitter 检查，减少字符串 / 注释中的错误补全。
--
-- 依赖:
--   - windwp/nvim-autopairs
--   - nvim-treesitter/nvim-treesitter
--
-- ============================================================================

return {
	"windwp/nvim-autopairs",

	-- --------------------------------------------------------------------------
	-- 加载时机
	-- --------------------------------------------------------------------------

	event = "InsertEnter",

	config = function()
		local ok, autopairs = pcall(require, "nvim-autopairs")
		if not ok then
			return
		end

		-- ------------------------------------------------------------------------
		-- 基础配置
		-- ------------------------------------------------------------------------
		--
		-- check_ts:
		--   启用 Treesitter 上下文检查。
		--
		-- enable_check_bracket_line:
		--   如果当前行后面已经有右括号，尽量避免重复补全。
		--
		-- ignored_next_char:
		--   如果下一个字符是这些字符，插件会更谨慎地补全。
		--   主要用于减少代码中间插入符号时的干扰。
		--
		-- fast_wrap:
		--   快速包裹功能。
		--   例如选中 / 定位后快速用括号包住内容。
		--
		-- ------------------------------------------------------------------------

		autopairs.setup({
			-- 使用 Treesitter 判断当前语法区域
			check_ts = true,

			-- 当前行存在右括号时，减少重复补全
			enable_check_bracket_line = true,

			-- 是否启用移动右括号
			enable_moveright = true,

			-- 是否在按 Backspace 时一起删除配对符号
			enable_bracket_in_quote = true,

			-- 是否在输入右括号时自动跳过已经存在的右括号
			enable_afterquote = true,

			-- 禁用某些 filetype，避免影响特殊输入窗口
			disable_filetype = {
				"TelescopePrompt",
				"spectre_panel",
				"snacks_picker_input",
				"DressingInput",
				"vim",
			},

			-- 如果下一个字符是这些，减少自动补全干扰
			ignored_next_char = "[%w%.]",

			-- 快速包裹配置
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = [=[[%'%"%>%]%)%}%,]]=],
				end_key = "$",
				before_key = "h",
				after_key = "l",
				cursor_pos_before = true,
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				manual_position = true,
				highlight = "Search",
				highlight_grey = "Comment",
			},
		})
	end,
}
