-- ============================================================================
-- 文件管理器: stevearc/oil.nvim
-- ============================================================================
--
-- 功能说明:
--   • 使用 oil.nvim 替代 netrw / nvim-tree 作为文件管理器
--   • 将文件系统当成普通 Neovim buffer 编辑
--   • 支持直接重命名、移动、删除、新建文件和目录
--   • 支持浮动窗口、当前窗口、左侧侧边窗三种打开方式
--   • 适合配合 fzf-lua 使用：fzf-lua 负责搜索，oil.nvim 负责文件结构管理
--
-- 配置效果:
--   ├─ 普通打开: - 打开当前文件所在目录
--   ├─ 浮动窗口: <leader>e 使用浮动窗口打开文件管理器
--   ├─ 当前窗口: <leader>E 在当前窗口打开文件管理器
--   ├─ 隐藏文件: g. 切换隐藏文件显示
--   ├─ 文件预览: p 预览当前文件
--   ├─ 外部打开: gx 使用系统默认程序打开文件
--   └─ 文件操作: 编辑目录 buffer 后使用 :w 保存操作
--
-- 使用方式:
--   • 回车: 打开文件 / 进入目录
--   • -: 返回上级目录
--   • q: 关闭 oil 窗口
--   • r: 刷新目录
--   • p: 预览文件
--   • :w: 保存文件操作
--
-- Lazy.nvim 说明:
--   • cmd = "Oil" 表示执行 :Oil 时自动加载插件
--   • keys 表示按下快捷键时自动加载插件
--   • dependencies 用于声明 mini.icons 图标依赖
--   • opts 会自动传给 require("oil").setup(...)
--

-- ============================================================================
-- 左侧侧边栏打开函数
-- ============================================================================
--
-- 说明:
--   • oil.nvim 默认不是传统文件树侧边栏
--   • 这里通过 topleft 35vnew 手动创建左侧垂直窗口
--   • 然后在该窗口中打开当前文件所在目录
--
-- 行为:
--   • 如果当前 buffer 是普通文件，则打开当前文件所在目录
--   • 如果当前 buffer 没有实际文件路径，则打开当前工作目录
--   • 如果已经存在 oil 窗口，则不会重复打开多个侧边栏

local function open_oil_sidebar()
	-- 避免重复打开多个 oil 侧边栏
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)

		if vim.bo[buf].filetype == "oil" then
			vim.api.nvim_set_current_win(win)
			return
		end
	end

	-- 获取当前文件所在目录
	local dir = vim.fn.expand("%:p:h")

	-- 如果当前 buffer 没有具体文件路径，则使用当前工作目录
	if dir == "" or dir == "." then
		dir = vim.fn.getcwd()
	end

	-- 在左侧创建 35 列宽的垂直窗口
	vim.cmd("topleft 35vnew")

	-- 固定侧边栏宽度
	vim.wo.winfixwidth = true

	-- 侧边栏不显示行号和 signcolumn
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.signcolumn = "no"

	-- 在当前侧边窗口中打开 oil
	require("oil").open(dir)
end

return {
	{
		"stevearc/oil.nvim",

		-- 命令触发加载
		-- 不使用 VimEnter，因此启动 Neovim 时不会默认打开文件管理器
		cmd = {
			"Oil",
		},

		-- 图标依赖
		dependencies = {
			"nvim-mini/mini.icons",
		},

		-- ====================================================================
		-- 外部快捷键配置
		-- ====================================================================
		--
		-- 这些快捷键在普通 buffer 中使用，用于打开 oil.nvim。

		keys = {
			{
				"-",
				function()
					require("oil").open()
				end,
				desc = "打开当前文件所在目录",
			},

			{
				"<leader>e",
				function()
					require("oil").open_float()
				end,
				desc = "浮动文件管理器",
			},

			{
				"<leader>E",
				function()
					require("oil").open()
				end,
				desc = "当前窗口文件管理器",
			},
		},

		opts = {
			-- ====================================================================
			-- 基础行为
			-- ====================================================================

			-- 打开目录时使用 oil.nvim 替代 netrw
			default_file_explorer = true,

			-- 删除文件时是否移动到系统回收站
			-- false 表示直接删除
			delete_to_trash = false,

			-- 简单编辑是否跳过确认
			-- false 表示仍然显示确认窗口，更安全
			skip_confirm_for_simple_edits = false,

			-- 选择新 entry 时，如果当前目录有未保存操作，则提示保存
			prompt_save_on_select_new_entry = true,

			-- 文件系统变更监听
			-- true 表示外部文件变化时 oil 会尝试刷新
			watch_for_changes = true,

			-- 光标约束
			-- editable 表示光标尽量限制在可编辑文件名区域
			constrain_cursor = "editable",

			-- 清理延迟
			cleanup_delay_ms = 2000,

			-- ====================================================================
			-- 显示列配置
			-- ====================================================================
			--
			-- 可选列:
			--   • icon: 文件 / 目录图标
			--   • permissions: 权限
			--   • size: 文件大小
			--   • mtime: 修改时间
			--
			-- 建议:
			--   日常开发只保留 icon，信息更干净。

			columns = {
				"icon",
			},

			-- ====================================================================
			-- Buffer 配置
			-- ====================================================================

			buf_options = {
				-- 不把 oil buffer 加入普通 buffer 列表
				-- 避免 bufferline 里出现 oil buffer
				buflisted = false,

				-- 隐藏时保留 buffer
				bufhidden = "hide",
			},

			-- ====================================================================
			-- 窗口配置
			-- ====================================================================

			win_options = {
				-- 文件管理器中不显示行号
				number = false,
				relativenumber = false,

				-- 不显示 signcolumn
				signcolumn = "no",

				-- 不自动换行
				wrap = false,

				-- 不启用拼写检查
				spell = false,

				-- 不显示折叠列
				foldcolumn = "0",
			},

			-- ====================================================================
			-- 浮动窗口配置
			-- ====================================================================

			float = {
				-- 四周留白
				padding = 2,

				-- 最大宽度和高度
				max_width = 0.85,
				max_height = 0.80,

				-- 圆角边框
				border = "rounded",

				-- 浮动窗口透明度
				win_options = {
					winblend = 0,
				},
			},

			-- ====================================================================
			-- 文件预览窗口配置
			-- ====================================================================

			preview = {
				-- 预览窗口最大宽度
				max_width = 0.90,

				-- 预览窗口最小宽度
				min_width = {
					40,
					0.40,
				},

				-- 预览窗口宽度比例
				width = 0.50,

				-- 预览窗口最大高度
				max_height = 0.90,

				-- 预览窗口最小高度
				min_height = {
					5,
					0.10,
				},

				-- 预览窗口高度比例
				height = 0.50,

				-- 圆角边框
				border = "rounded",

				win_options = {
					winblend = 0,
				},
			},

			-- ====================================================================
			-- 确认窗口配置
			-- ====================================================================
			--
			-- 当你重命名、移动、删除文件后执行 :w，
			-- oil.nvim 会弹出确认窗口显示将要执行的文件操作。

			confirmation = {
				max_width = 0.90,

				min_width = {
					40,
					0.40,
				},

				width = 0.50,

				max_height = 0.90,

				min_height = {
					5,
					0.10,
				},

				height = 0.50,

				border = "rounded",

				win_options = {
					winblend = 0,
				},
			},

			-- ====================================================================
			-- 文件显示配置
			-- ====================================================================

			view_options = {
				-- 默认显示隐藏文件
				show_hidden = true,

				-- 判断隐藏文件
				-- 以 . 开头的文件视为隐藏文件
				is_hidden_file = function(name, _)
					return vim.startswith(name, ".")
				end,

				-- 判断总是隐藏的文件
				-- 这里不强制隐藏任何文件，统一交给 g. 控制
				is_always_hidden = function(_, _)
					return false
				end,

				-- 自然排序
				-- 例如 file2 会排在 file10 前面
				natural_order = true,

				-- 区分大小写排序
				case_insensitive = false,

				-- 排序规则
				-- 先按类型排序，再按名称排序
				sort = {
					{
						"type",
						"asc",
					},
					{
						"name",
						"asc",
					},
				},
			},

			-- ====================================================================
			-- LSP 文件操作
			-- ====================================================================
			--
			-- 说明:
			--   某些 LSP 支持文件重命名通知。
			--   例如 Go / TypeScript 项目中，重命名文件可能需要同步更新引用。
			--
			-- autosave_changes:
			--   false 表示不自动保存 LSP 修改，避免插件自动改项目文件。

			lsp_file_methods = {
				timeout_ms = 1000,
				autosave_changes = false,
			},

			-- ====================================================================
			-- Oil 内部快捷键配置
			-- ====================================================================
			--
			-- 这些快捷键只在 oil.nvim 的目录 buffer 中生效。

			keymaps = {
				-- 显示帮助
				["g?"] = "actions.show_help",

				-- 打开文件 / 进入目录
				["<CR>"] = "actions.select",

				-- 垂直分屏打开
				["<leader>v"] = "actions.select_vsplit",

				-- 水平分屏打开
				["<leader>s"] = "actions.select_split",

				-- 新 tab 打开
				["<leader>t"] = "actions.select_tab",

				-- 预览文件
				["p"] = "actions.preview",

				-- 关闭 oil 窗口
				["q"] = "actions.close",

				-- 刷新当前目录
				["r"] = "actions.refresh",

				-- 返回上级目录
				["-"] = "actions.parent",

				-- 打开当前工作目录
				["_"] = "actions.open_cwd",

				-- 将当前目录设置为 cwd
				["`"] = "actions.cd",

				-- 将当前目录设置为 tab cwd
				["~"] = "actions.tcd",

				-- 修改排序方式
				["gs"] = "actions.change_sort",

				-- 使用系统默认程序打开文件
				["gx"] = "actions.open_external",

				-- 显示 / 隐藏隐藏文件
				["g."] = "actions.toggle_hidden",

				-- 切换回收站视图
				["g\\"] = "actions.toggle_trash",
			},
		},

		config = function(_, opts)
			require("oil").setup(opts)
		end,
	},
}
