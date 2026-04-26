-- ============================================================================
-- LSP 语言服务器配置: neovim/nvim-lspconfig
-- ============================================================================
-- 功能说明:
--   • 集成多个编程语言的语言服务器（LSP）
--   • 提供代码诊断、高亮、代码导航、重命名等功能
--   • 自动检测并仅加载已安装的 LSP 服务器
--   • Mason 包管理器自动安装和管理 LSP 二进制文件
-- 配置效果:
--   ├─ 实时诊断: 代码错误/警告即时显示
--   ├─ 代码补全: LSP 提供的智能代码补全
--   ├─ 导航: 跳转到定义、查找引用等功能
--   ├─ 信息提示: 悬停查看函数签名和文档
--   └─ 代码重构: 重命名、提取方法等操作
--
-- 支持的 LSP 服务器:
--   • lua_ls: Lua 语言
--   • bashls: Bash/Shell 脚本
--   • jsonls: JSON 文件
--   • yamlls: YAML 配置文件
--   • pyright: Python 语言

vim.pack.add({
  {
    src = "https://github.com/neovim/nvim-lspconfig",
    name = "nvim-lspconfig",
  },
  {
    src = "https://github.com/mason-org/mason.nvim",
    name = "mason.nvim",
  },
  {
    src = "https://github.com/mason-org/mason-lspconfig.nvim",
    name = "mason-lspconfig.nvim",
  },
})

-- ============================================================================
-- LSP 补全能力
-- ============================================================================
-- 如果你使用的是 blink.cmp，用 blink.cmp 提供的 capabilities。
-- 如果 blink.cmp 没有加载成功，则回退到 Neovim 默认 capabilities。

local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok_blink, blink_cmp = pcall(require, "blink.cmp")
if ok_blink then
  capabilities = blink_cmp.get_lsp_capabilities(capabilities)
end

-- ============================================================================
-- 要使用的 LSP 服务器
-- ============================================================================

local servers = {
  -- 脚本 / 配置
  "lua_ls",                 -- Lua / Neovim 配置
  "bashls",                 -- Bash / Shell
  "jsonls",                 -- JSON
  "yamlls",                 -- YAML

  -- 常用后端语言
  "gopls",                  -- Go，官方 Go language server
  "rust_analyzer",          -- Rust
  "clangd",                 -- C / C++
  "jdtls",                  -- Java
  "kotlin_language_server", -- Kotlin

  -- 前端 / Web
  "html",                   -- HTML
  "cssls",                  -- CSS
  "ts_ls",                  -- JavaScript / TypeScript

  -- Python
  "pyright",                -- Python
}

-- ============================================================================
-- Mason 初始化
-- ============================================================================

require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = servers,

  -- 不让 mason-lspconfig 自动启用。
  -- 下面我们会手动只启用已安装的 server，便于控制和排错。
  automatic_enable = false,
})

-- ============================================================================
-- 通用 LSP 配置
-- ============================================================================

for _, server_name in ipairs(servers) do
  vim.lsp.config(server_name, {
    capabilities = capabilities,
  })
end

-- ============================================================================
-- Lua LSP 特定配置
-- ============================================================================

vim.lsp.config("lua_ls", {
  capabilities = capabilities,

  settings = {
    Lua = {
      diagnostics = {
        -- 避免 Neovim 配置里使用 vim 全局变量时报 undefined-global
        globals = {
          "vim",
        },
      },

      workspace = {
        checkThirdParty = false,
      },

      telemetry = {
        enable = false,
      },
    },
  },
})

-- ============================================================================
-- 启用已安装的 LSP 服务器
-- ============================================================================

for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
  vim.lsp.enable(server_name)
end

-- ============================================================================
-- 诊断显示配置
-- ============================================================================

vim.diagnostic.config({
  virtual_text = true,      -- 在代码行右侧显示诊断
  signs = true,             -- 在行号栏显示诊断标记
  underline = true,         -- 在有问题的代码下划线
  update_in_insert = false, -- 插入模式下不更新诊断
  severity_sort = true,     -- 按严重程度排序诊断
})

-- ============================================================================
-- LSP 快捷键
-- ============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP keymaps",
  callback = function(event)
    local bufnr = event.buf

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = bufnr,
        silent = true,
        noremap = true,
        desc = desc,
      })
    end

    map("n", "gd", vim.lsp.buf.definition, "跳转到定义")
    map("n", "gD", vim.lsp.buf.declaration, "跳转到声明")
    map("n", "gi", vim.lsp.buf.implementation, "跳转到实现")
    map("n", "gr", vim.lsp.buf.references, "查找引用")

    map("n", "K", vim.lsp.buf.hover, "查看文档")
    map("n", "<leader>rn", vim.lsp.buf.rename, "重命名")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "代码操作")

    map("n", "<leader>cd", vim.diagnostic.open_float, "查看当前行诊断")
    map("n", "[d", vim.diagnostic.goto_prev, "上一个诊断")
    map("n", "]d", vim.diagnostic.goto_next, "下一个诊断")
  end,
})