-- ============================================================================
-- Buffer 标签栏美化: akinsho/bufferline.nvim
-- ============================================================================
-- 功能说明:
--   • 在编辑器顶部显示打开的 buffer 标签栏
--   • 支持斜线风格分隔符，美观简洁
--   • 显示 LSP 诊断信息（错误/警告/信息/提示数量）
--   • 快捷键: Shift+h 上一个buffer, Shift+l 下一个buffer
-- 配置效果:
--   ├─ 美化: 现代的标签栏设计，斜线分隔符视觉效果好
--   ├─ 诊断: 直观显示各buffer的错误/警告状态
--   └─ 导航: 快速在多个buffer之间切换

vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    name = "nvim-web-devicons",
  },
  {
    src = "https://github.com/akinsho/bufferline.nvim",
    name = "bufferline.nvim",
  },
})

require("bufferline").setup({
  options = {
    mode = "buffers",              -- 显示 buffer 而不是 tab
    separator_style = "slant",     -- 斜线分隔符
    always_show_bufferline = true, -- 始终显示标签栏

    show_buffer_close_icons = false, -- 隐藏 buffer 关闭按钮
    show_close_icon = false,         -- 隐藏右侧关闭按钮

    diagnostics = "nvim_lsp", -- 显示 LSP 诊断信息

    -- 自定义诊断显示格式：
    -- 例如 E2 W1 表示 2 个错误、1 个警告
    diagnostics_indicator = function(_, _, diag)
      local icons = {
        Error = "E",
        Warn = "W",
        Info = "I",
        Hint = "H",
      }

      local result = {}

      for level, count in pairs(diag) do
        if icons[level] and count > 0 then
          table.insert(result, string.format("%s%d", icons[level], count))
        end
      end

      return table.concat(result, " ")
    end,
  },
})

-- 快捷键配置
local map_opts = {
  noremap = true,
  silent = true,
}

vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", map_opts) -- Shift+l: 下一个 buffer
vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", map_opts) -- Shift+h: 上一个 buffer