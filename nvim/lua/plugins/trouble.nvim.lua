-- ============================================================================
-- 诊断列表增强: folke/trouble.nvim
-- ============================================================================
--
-- 功能说明:
--   • 使用 Trouble 集中显示 diagnostics、LSP 引用、quickfix、location list 等信息
--   • 适合查看项目中的错误、警告、提示
--   • 比直接看虚拟文本更适合处理大量诊断信息
--
-- 配置效果:
--   ├─ 项目诊断: <leader>xx 查看当前 Neovim 已知的 diagnostics
--   ├─ 当前文件诊断: <leader>xX 只查看当前 buffer 的 diagnostics
--   ├─ 文件符号: <leader>cs 查看当前文件 symbols
--   ├─ LSP 信息: <leader>cl 查看定义、引用、实现等
--   ├─ Quickfix: <leader>xq 查看 quickfix
--   └─ Loclist: <leader>xl 查看 location list
--
-- 注意:
--   • Trouble v3 中 icons 不是 boolean
--   • 不要写 icons = true
--   • 如果要自定义 icons，必须写成 icons = { ... }
--   • 项目诊断显示的是 Neovim diagnostics 系统里已有的数据，不是主动全项目扫描
--
-- Lazy.nvim 说明:
--   • cmd = "Trouble" 表示执行 :Trouble 时自动加载
--   • keys 表示按下快捷键时自动加载
--   • opts = {} 使用 Trouble v3 默认配置，避免旧配置导致兼容问题
--

return {
    {
        "folke/trouble.nvim",

        cmd = {
            "Trouble",
        },

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "项目诊断",
            },

            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "当前文件诊断",
            },

            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "当前文件符号",
            },

            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP 定义 / 引用 / 实现",
            },

            {
                "<leader>xq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix 列表",
            },

            {
                "<leader>xl",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List",
            },
        },

        opts = {
            -- ====================================================================
            -- 基础配置
            -- ====================================================================

            -- 打开 Trouble 后是否自动聚焦到 Trouble 窗口
            focus = false,

            -- 没有结果时是否显示警告
            warn_no_results = true,

            -- 没有结果时是否仍然打开窗口
            open_no_results = false,
        },
    },
}
