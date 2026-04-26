-- ============================================================================
-- 命令行增强: folke/noice.nvim
-- ============================================================================
-- 功能说明:
--   • 美化 Neovim 默认命令行、搜索框、消息提示和 LSP 文档窗口
--   • 使用居中浮动窗口显示命令输入
--   • 使用 popupmenu 显示命令补全菜单
--   • 优化 LSP hover、signature help、markdown 文档渲染效果
-- 配置效果:
--   ├─ 命令增强: 使用居中浮动命令框
--   ├─ 补全菜单: 使用 nui popupmenu 显示命令补全
--   ├─ LSP 美化: hover 和签名帮助显示更清晰
--   └─ 消息管理: 长消息自动进入 split，减少界面干扰
--
-- 健康检查:
--   • 如果 noice 行为异常，可以执行 :checkhealth noice

-- ============================================================================
-- 插件安装
-- ============================================================================

vim.pack.add({
  {
    src = "https://github.com/rcarriga/nvim-notify",
    name = "nvim-notify",
  },
  {
    src = "https://github.com/MunifTanjim/nui.nvim",
    name = "nui.nvim",
  },
  {
    src = "https://github.com/folke/noice.nvim",
    name = "noice.nvim",
  },
})

-- ============================================================================
-- 通知插件配置
-- ============================================================================

require("notify").setup({
  timeout = 2500,
  render = "compact",
})

vim.notify = require("notify")

-- ============================================================================
-- Noice 配置
-- ============================================================================

require("noice").setup({
  -- ==========================================================================
  -- LSP 显示增强
  -- ==========================================================================

  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },

  -- ==========================================================================
  -- 命令行配置
  -- ==========================================================================
  -- 使用居中的浮动命令行，而不是底部命令行。

  cmdline = {
    enabled = true,
    view = "cmdline_popup",
  },

  -- ==========================================================================
  -- 命令补全菜单
  -- ==========================================================================
  -- 使用 noice 自带的 nui popupmenu。

  popupmenu = {
    enabled = true,
    backend = "nui",
  },

  -- ==========================================================================
  -- 视图配置
  -- ==========================================================================

  views = {
    -- 居中的命令输入框
    cmdline_popup = {
      position = {
        row = "40%",
        col = "50%",
      },
      size = {
        min_width = 60,
        width = "60%",
        height = "auto",
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = {
          Normal = "Normal",
          FloatBorder = "NoiceCmdlinePopupBorder",
        },
      },
    },

    -- 命令补全菜单
    popupmenu = {
      relative = "editor",
      position = {
        row = "45%",
        col = "50%",
      },
      size = {
        min_width = 60,
        width = "60%",
        height = "auto",
        max_height = 15,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = {
          Normal = "Normal",
          FloatBorder = "NoiceCmdlinePopupBorder",
        },
      },
    },
  },

  -- ==========================================================================
  -- 预设配置
  -- ==========================================================================

  presets = {
    bottom_search = false,        -- 搜索也使用浮动窗口
    command_palette = false,      -- 手动配置位置，不使用预设
    long_message_to_split = true, -- 长消息自动进入 split
    inc_rename = false,
    lsp_doc_border = false,
  },
})