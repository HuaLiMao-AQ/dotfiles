-- ============================================================================
-- Lua 文件类型修复: 覆盖 Neovim 0.12 内置 ftplugin/lua.lua
-- ============================================================================
--
-- 功能说明:
--   • 阻止 Neovim 0.12 内置 lua ftplugin 自动调用 vim.treesitter.start()
--   • 避免 Lua parser / query 版本不匹配导致 Invalid field name "operator"
--   • 保留基本的 Lua 编辑体验，例如注释格式、缩进和 conceal 设置
--
-- 配置效果:
--   ├─ 修复: 打开 .lua 文件时不再由内置 ftplugin 自动启动 Tree-sitter
--   ├─ 稳定: 避免启动阶段直接抛出 E5113 / Query error
--   └─ 兼容: 后续可以由你自己的 nvim-treesitter 配置决定是否启用 Lua 高亮
--
-- 注意:
--   • 这个文件必须放在 ftplugin/lua.lua，而不是 after/ftplugin/lua.lua
--   • after/ftplugin/lua.lua 太晚，内置 ftplugin 已经先报错了
--   • 不要直接修改 /opt/homebrew/Cellar/neovim/... 里的 runtime 文件
--

-- 告诉后续的 lua ftplugin：当前 buffer 已经处理过
-- 这样可以阻止 Neovim 内置 runtime/ftplugin/lua.lua 继续执行
vim.b.did_ftplugin = true

-- 基础 Lua 注释格式
vim.bo.commentstring = "-- %s"
vim.bo.comments = ":---,:--"

-- 基础缩进设置
vim.bo.expandtab = true
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

-- 避免 conceal 影响 Lua 配置文件阅读
vim.wo.conceallevel = 0
