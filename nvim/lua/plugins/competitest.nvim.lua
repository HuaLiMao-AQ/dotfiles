-- ============================================================================
-- HuaLiMao-AQ/competitest.nvim 算法竞赛测试工具
-- ============================================================================
--
-- 功能说明:
--   用于算法竞赛 / 蓝桥杯 / 洛谷 / Codeforces 的本地样例测试。
--
-- 配置效果:
--   ├─ 支持从 Competitive Companion 接收题目样例
--   ├─ 支持自动生成 C++ 代码文件
--   ├─ 支持本地编译、运行、对比样例输出
--   ├─ 支持手动添加 / 编辑 / 删除 testcase
--   └─ 默认使用 C++11
--
-- 依赖:
--   - xeluxee/competitest.nvim
--   - MunifTanjim/nui.nvim
--   - 浏览器插件 Competitive Companion
--
-- ============================================================================

return {
	"HuaLiMao-AQ/competitest.nvim",

	dependencies = {
		"MunifTanjim/nui.nvim",
	},

	cmd = {
		"CompetiTest",
	},

	keys = {
		-- 运行当前题目的所有测试样例
		{
			"<leader>cr",
			"<cmd>CompetiTest run<CR>",
			desc = "CP: Run testcases",
		},

		-- 从 Competitive Companion 接收单个题目
		{
			"<leader>cp",
			"<cmd>CompetiTest receive problem<CR>",
			desc = "CP: Receive problem",
		},

		-- 从 Competitive Companion 接收整场比赛
		{
			"<leader>cc",
			"<cmd>CompetiTest receive contest<CR>",
			desc = "CP: Receive contest",
		},

		-- 添加测试样例
		{
			"<leader>cA",
			"<cmd>CompetiTest add_testcase<CR>",
			desc = "CP: Add testcase",
		},

		-- 编辑测试样例
		{
			"<leader>ce",
			"<cmd>CompetiTest edit_testcase<CR>",
			desc = "CP: Edit testcase",
		},

		-- 删除测试样例
		{
			"<leader>cD",
			"<cmd>CompetiTest delete_testcase<CR>",
			desc = "CP: Delete testcase",
		},
	},

	config = function()
		local competitest = require("competitest")

		-- ------------------------------------------------------------------------
		-- 路径配置
		-- ------------------------------------------------------------------------
		local nvim_config = vim.fn.stdpath("config")
		local cp_template = nvim_config .. "/templates/competitest/main.cpp"

		competitest.setup({
			-- ======================================================================
			-- 基础行为
			-- ======================================================================

			-- 是否在打开测试窗口时保存当前文件
			save_current_file = true,

			-- 是否在运行前自动保存当前文件
			save_all_files = false,

			-- 测试运行结束后是否自动关闭窗口
			close_output_win = false,

			-- 测试完成后是否自动打开输出窗口
			open_output_win = true,

			-- ======================================================================
			-- 模板配置
			-- ======================================================================

			-- 接收题目时自动使用模板
			template_file = {
				cpp = cp_template,
			},

			-- 让模板中的 $(PROBLEM)、$(CONTEST)、$(URL) 等变量生效
			evaluate_template_modifiers = true,

			-- 默认接收为 C++ 文件
			received_files_extension = "cpp",

			-- 单题接收路径
			-- 示例:
			--   ./P1001.cpp
			--   ./A.cpp
			received_problems_path = "$(CWD)/$(PROBLEM).$(FEXT)",

			-- 比赛目录
			-- 示例:
			--   ./Codeforces/Codeforces Round 900/
			received_contests_directory = "$(CWD)/$(JUDGE)/$(CONTEST)",

			-- 比赛中每题的文件路径
			received_contests_problems_path = "$(PROBLEM).$(FEXT)",

			-- ======================================================================
			-- 编译配置
			-- ======================================================================

			compile_command = {
				cpp = {
					exec = "clang++",
					args = {
						"-std=c++11",
						"-O2",
						"-Wall",
						"-Wextra",
						"$(FNAME)",
						"-o",
						"$(FNPATH)",
					},
				},

				c = {
					exec = "clang",
					args = {
						"-O2",
						"-Wall",
						"-Wextra",
						"$(FNAME)",
						"-o",
						"$(FNPATH)",
					},
				},

				java = {
					exec = "javac",
					args = {
						"$(FNAME)",
					},
				},
			},

			-- ======================================================================
			-- 运行配置
			-- ======================================================================

			run_command = {
				cpp = {
					exec = "$(FNPATH)",
				},

				c = {
					exec = "$(FNPATH)",
				},

				python = {
					exec = "python3",
					args = {
						"$(FNAME)",
					},
				},

				java = {
					exec = "java",
					args = {
						"$(FNPATH)",
					},
				},
			},

			-- ======================================================================
			-- UI 配置
			-- ======================================================================

			runner_ui = {
				interface = "split",

				selector_show_nu = true,
				selector_show_rnu = false,

				show_nu = true,
				show_rnu = false,

				mappings = {
					run_again = "R",
					run_all_again = "<C-r>",
					kill = "K",
					kill_all = "<C-k>",
					view_input = "i",
					view_output = "a",
					view_stdout = "o",
					view_stderr = "e",
					toggle_diff = "d",
					close = "q",
				},

				viewer = {
					width = 0.5,
					height = 0.5,
					show_nu = true,
					show_rnu = false,
					close_mappings = {
						"q",
						"<Esc>",
					},
				},
			},

			-- ======================================================================
			-- 测试样例文件保存策略
			-- ======================================================================

			testcases_directory = ".testcases/$(FNOEXT)",

			testcases_input_file_format = "input$(TCNUM).txt",
			testcases_output_file_format = "output$(TCNUM).txt",

			-- ======================================================================
			-- 输出比对
			-- ======================================================================

			-- 是否忽略输出末尾空白
			check_trailing_spaces = false,

			-- 是否忽略空行数量差异
			check_blank_lines = false,

			-- ======================================================================
			-- Competitive Companion 接收配置
			-- ======================================================================

			companion_port = 27121,

			-- 是否接收完整比赛
			receive_print_message = true,

			-- ======================================================================
			-- 测试超时
			-- ======================================================================
			testcase_timeout = 3000,
		})
	end,
}
