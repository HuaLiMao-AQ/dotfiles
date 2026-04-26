-- ============================================================================
-- 工具管理器: mason.nvim
-- ============================================================================
--
-- 功能说明:
--   • 使用 mason.nvim 管理 Neovim 相关开发工具
--   • 统一安装 LSP server、formatter、linter、DAP server
--   • 避免手动到系统里到处安装 lua_ls / pyright / stylua / prettier 等工具
--   • 配合 mason-lspconfig.nvim 管理 LSP 安装
--   • 配合 mason-tool-installer.nvim 管理 formatter / linter 安装
--
-- 配置效果:
--   ├─ LSP 管理: lua_ls / pyright / gopls / clangd / jdtls 等
--   ├─ Formatter 管理: stylua / shfmt / prettier / ruff / ktlint 等
--   ├─ UI 界面: 使用 :Mason 打开工具管理界面
--   └─ 跨平台: macOS / Linux / Windows 都可以使用
--
-- 注意:
--   • Mason 是 Neovim 插件，不是 macOS 系统软件
--   • 不需要 brew install mason
--   • Mason 安装的工具主要给 Neovim 使用
--   • Go / Rust / Node / Java 这类基础语言环境仍然建议用系统方式安装
--
-- Lazy.nvim 说明:
--   • cmd = "Mason" 表示执行 :Mason 时自动加载
--   • build = ":MasonUpdate" 表示安装或更新后刷新 Mason registry
--

return {
    {
        "mason-org/mason.nvim",

        -- 命令触发加载
        cmd = {
            "Mason",
        },

        -- 更新 Mason registry
        build = ":MasonUpdate",

        opts = {
            -- ====================================================================
            -- UI 配置
            -- ====================================================================

            ui = {
                -- 圆角边框
                border = "rounded",

                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },

            -- ====================================================================
            -- 安装路径
            -- ====================================================================
            --
            -- 默认安装到:
            --   ~/.local/share/nvim/mason
            --
            -- 不建议手动修改，避免 PATH 和插件识别混乱。

            install_root_dir = vim.fn.stdpath("data") .. "/mason",
        },
    },
}

