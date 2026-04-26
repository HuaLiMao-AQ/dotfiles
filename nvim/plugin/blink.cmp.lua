-- ============================================================================
-- 代码补全引擎: saghen/blink.cmp
-- ============================================================================
-- 功能说明:
--   • 提供高性能代码补全，替代传统 nvim-cmp
--   • 支持 LSP、路径、代码片段、Buffer 内容等补全来源
--   • 内置 Rust 模糊匹配器，补全速度快，容错能力强
--   • 支持函数签名提示和自动文档弹窗
-- 配置效果:
--   ├─ 智能补全: 自动从 LSP / path / snippets / buffer 获取候选项
--   ├─ 输入友好: Enter 确认补全，Tab / Shift-Tab 切换候选项
--   ├─ 文档提示: 自动显示补全文档，Ctrl-b / Ctrl-f 滚动文档
--   ├─ 签名提示: 输入函数参数时显示 signature help
--   └─ 性能较好: 优先使用 Rust fuzzy matcher，失败时给出警告

vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = "v1",
    name = "blink.cmp",
  },
})

require("blink.cmp").setup({
  keymap = {
    preset = "enter",

    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },

    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },

    ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  sources = {
    default = {
      "lsp",
      "path",
      "snippets",
      "buffer",
    },
  },

  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },

  completion = {
    keyword = {
      range = "prefix",
    },

    menu = {
      draw = {
        treesitter = {
          "lsp",
        },
      },
    },

    trigger = {
      show_on_trigger_character = true,
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
  },

  signature = {
    enabled = true,
  },
})