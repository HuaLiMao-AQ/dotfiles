-- ============================================================================
-- Clang Format Helper
-- ============================================================================
--
-- 功能说明:
--   提供一个 Neovim 自定义命令，用于快速复制统一的 .clang-format
--   到当前目录或指定目录。
--
-- 使用方式:
--   :CFInit
--     复制到当前工作目录
--
--   :CFInit ~/Algorithm
--     复制到指定目录
--
--   :CFInit .
--     复制到当前目录
--
--   :CFInit!
--     强制覆盖已有 .clang-format
--
-- 配置效果:
--   1. 不需要每次手动复制 .clang-format。
--   2. 支持自动创建目标目录。
--   3. 默认不覆盖已有 .clang-format，防止误覆盖项目配置。
--   4. 使用 ! 可以强制覆盖。
--
-- ============================================================================

local M = {}

-- 统一的 clang-format 模板路径
local nvim_config = vim.fn.stdpath("config")
local source_file = nvim_config .. "/templates/cp.clang-format"

-- 判断文件是否存在
local function file_exists(path)
	return vim.fn.filereadable(path) == 1
end

-- 判断目录是否存在
local function dir_exists(path)
	return vim.fn.isdirectory(path) == 1
end

-- 复制文件
local function copy_file(src, dst)
	local lines = vim.fn.readfile(src)
	vim.fn.writefile(lines, dst)
end

-- 创建 :CFInit 命令
function M.setup()
	vim.api.nvim_create_user_command("CFInit", function(opts)
		-- --------------------------------------------------------------------
		-- 目标目录
		-- --------------------------------------------------------------------
		--
		-- 如果用户传了参数:
		--   :CFInit ~/Algorithm
		-- 就复制到该目录。
		--
		-- 如果没传参数:
		--   :CFInit
		-- 就复制到当前工作目录。
		--
		-- --------------------------------------------------------------------

		local target_dir

		if opts.args ~= nil and opts.args ~= "" then
			target_dir = vim.fn.expand(opts.args)
		else
			target_dir = vim.fn.getcwd()
		end

		target_dir = vim.fn.fnamemodify(target_dir, ":p")
		local target_file = target_dir .. "/.clang-format"

		-- --------------------------------------------------------------------
		-- 检查源文件
		-- --------------------------------------------------------------------

		if not file_exists(source_file) then
			vim.notify("clang-format template not found: " .. source_file, vim.log.levels.ERROR)
			return
		end

		-- --------------------------------------------------------------------
		-- 检查目标目录
		-- --------------------------------------------------------------------

		if not dir_exists(target_dir) then
			vim.fn.mkdir(target_dir, "p")
		end

		-- --------------------------------------------------------------------
		-- 防止误覆盖
		-- --------------------------------------------------------------------
		--
		-- 默认不覆盖已有 .clang-format。
		-- 如果需要覆盖，使用:
		--   :CFInit!
		--
		-- --------------------------------------------------------------------

		if file_exists(target_file) and not opts.bang then
			vim.notify(
				".clang-format already exists: " .. target_file .. "\nUse :CFInit! to overwrite.",
				vim.log.levels.WARN
			)
			return
		end

		copy_file(source_file, target_file)

		vim.notify("Copied .clang-format to: " .. target_file, vim.log.levels.INFO)
	end, {
		nargs = "?",
		bang = true,
		complete = "dir",
		desc = "Copy clang-format template to target directory",
	})
end

return M
