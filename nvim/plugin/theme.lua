-- ============================================================================
-- 主题配置: Tokyonight 颜色方案
-- ============================================================================
-- 功能说明:
--   • 使用 Tokyonight 夜间模式作为编辑器主题
--   • 提供现代化的深色配色方案，减少眼睛疲劳
--   • 配置终端颜色支持，确保在各类程序中显示正确的颜色

vim.pack.add({
  {
    src = "https://github.com/folke/tokyonight.nvim",
    name = "tokyonight.nvim",
  },
})

require("tokyonight").setup({
  style = "night",        -- 使用夜间模式
  transparent = false,    -- 禁用透明背景
  terminal_colors = true, -- 启用终端颜色支持
})

vim.cmd.colorscheme("tokyonight")