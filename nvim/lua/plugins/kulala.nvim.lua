-- ============================================================================
-- REST 请求客户端: mistweaverco/kulala.nvim
-- ============================================================================
--
-- 功能说明:
--   • 在 Neovim 中直接编辑和发送 .http / .rest 请求
--   • 支持 HTTP、GraphQL、gRPC、WebSocket 等请求场景
--   • 支持环境变量、请求重放、复制为 cURL、从 cURL 创建请求
--   • 适合替代独立 REST Client 工具，直接在配置和项目里调试接口
--
-- 配置效果:
--   ├─ <leader>Rs: 发送当前请求
--   ├─ <leader>Ra: 发送当前文件中的所有请求
--   ├─ <leader>Rr: 重放上一次请求
--   ├─ <leader>Rb: 打开 Kulala scratchpad
--   ├─ <leader>Rc: 复制当前请求为 cURL
--   ├─ <leader>RC: 从剪贴板 cURL 创建请求
--   └─ <leader>Re: 选择请求环境
--
-- 注意:
--   • Kulala 依赖系统 curl，可用 :checkhealth kulala 检查环境
--   • 这里关闭插件默认全局快捷键，避免和自定义 keymaps 重复
--
-- Lazy.nvim 说明:
--   • ft = { "http", "rest" } 表示打开 REST 请求文件时加载
--   • keys 表示按下 REST 快捷键时也会自动加载
--   • opts 会自动传给 require("kulala").setup(...)
--

return {
	{
		"mistweaverco/kulala.nvim",
		ft = {
			"http",
			"rest",
		},
		keys = {
			{
				"<leader>Rs",
				function()
					require("kulala").run()
				end,
				mode = {
					"n",
					"v",
				},
				desc = "发送请求",
			},
			{
				"<leader>Ra",
				function()
					require("kulala").run_all()
				end,
				mode = {
					"n",
					"v",
				},
				desc = "发送全部请求",
			},
			{
				"<leader>Rr",
				function()
					require("kulala").replay()
				end,
				desc = "重放上次请求",
			},
			{
				"<leader>Rb",
				function()
					require("kulala").scratchpad()
				end,
				desc = "打开请求草稿",
			},
			{
				"<leader>Rc",
				function()
					require("kulala").copy()
				end,
				desc = "复制为 cURL",
			},
			{
				"<leader>RC",
				function()
					require("kulala").from_curl()
				end,
				desc = "从 cURL 创建请求",
			},
			{
				"<leader>Re",
				function()
					require("kulala").set_selected_env()
				end,
				desc = "选择请求环境",
			},
		},
		opts = {
			global_keymaps = false,
			global_keymaps_prefix = "<leader>R",
			kulala_keymaps_prefix = "",
		},
	},
}
