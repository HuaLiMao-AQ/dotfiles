-- ============================================================================
-- Git 行状态显示: lewis6991/gitsigns.nvim
-- ============================================================================
--
-- 功能说明:
--   • 在 signcolumn 显示当前文件的 Git 修改状态
--   • 支持查看、暂存、撤销当前 hunk
--   • 支持在修改块之间快速跳转
--   • 支持查看当前行 blame 信息
--
-- 配置效果:
--   ├─ 行状态: 左侧显示新增、修改、删除标记
--   ├─ Hunk 操作: 可以单独 stage / reset 当前代码块
--   ├─ Hunk 预览: 浮动窗口查看当前代码块改动
--   ├─ Blame: 查看当前行最后一次修改信息
--   └─ 导航: 使用 ]c / [c 在 Git 改动之间跳转
--
-- 快捷键:
--   • ]c: 下一个 Git hunk
--   • [c: 上一个 Git hunk
--   • <leader>hs: 暂存当前 hunk
--   • <leader>hr: 撤销当前 hunk
--   • <leader>hS: 暂存整个文件
--   • <leader>hR: 撤销整个文件
--   • <leader>hp: 预览当前 hunk
--   • <leader>hb: 查看当前行 blame
--   • <leader>hd: 查看当前文件 diff
--
-- Lazy.nvim 说明:
--   • event = { "BufReadPre", "BufNewFile" } 表示读文件时加载
--   • on_attach 用于设置 buffer-local keymaps
--   • opts 会自动传给 require("gitsigns").setup(...)
--

return {
    {
        "lewis6991/gitsigns.nvim",

        -- 打开文件时加载
        event = {
            "BufReadPre",
            "BufNewFile",
        },

        opts = {
            -- ====================================================================
            -- 左侧 Git 标记
            -- ====================================================================

            signs = {
                add = {
                    text = "+",
                },
                change = {
                    text = "~",
                },
                delete = {
                    text = "_",
                },
                topdelete = {
                    text = "‾",
                },
                changedelete = {
                    text = "~",
                },
                untracked = {
                    text = "┆",
                },
            },

            -- 是否显示 signcolumn 标记
            signcolumn = true,

            -- 是否显示行号高亮
            numhl = false,

            -- 是否显示整行高亮
            linehl = false,

            -- 是否显示单词级别 diff
            word_diff = false,

            -- 当前文件最大行数限制
            -- 超过后禁用 gitsigns，避免大文件卡顿
            max_file_length = 40000,

            -- ====================================================================
            -- 当前行 blame
            -- ====================================================================

            current_line_blame = false,

            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 800,
                ignore_whitespace = false,
            },

            current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

            -- ====================================================================
            -- 预览窗口配置
            -- ====================================================================

            preview_config = {
                border = "rounded",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },

            -- ====================================================================
            -- 快捷键配置
            -- ====================================================================
            --
            -- 使用 on_attach 的原因:
            --   • gitsigns 只对 Git 管理的 buffer 生效
            --   • 快捷键应该只绑定到启用了 gitsigns 的 buffer 上
            --   • 避免在普通文件、临时 buffer 中污染快捷键

            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, {
                        buffer = bufnr,
                        silent = true,
                        noremap = true,
                        desc = desc,
                    })
                end

                -- ================================================================
                -- Hunk 导航
                -- ================================================================

                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({
                            "]c",
                            bang = true,
                        })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, "下一个 Git hunk")

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({
                            "[c",
                            bang = true,
                        })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, "上一个 Git hunk")

                -- ================================================================
                -- Hunk 操作
                -- ================================================================

                map("n", "<leader>hs", gitsigns.stage_hunk, "暂存当前 hunk")
                map("n", "<leader>hr", gitsigns.reset_hunk, "撤销当前 hunk")

                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({
                        vim.fn.line("."),
                        vim.fn.line("v"),
                    })
                end, "暂存选中 hunk")

                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk({
                        vim.fn.line("."),
                        vim.fn.line("v"),
                    })
                end, "撤销选中 hunk")

                map("n", "<leader>hS", gitsigns.stage_buffer, "暂存当前文件")
                map("n", "<leader>hR", gitsigns.reset_buffer, "撤销当前文件")

                -- ================================================================
                -- Hunk 预览 / Blame / Diff
                -- ================================================================

                map("n", "<leader>hp", gitsigns.preview_hunk, "预览当前 hunk")

                map("n", "<leader>hb", function()
                    gitsigns.blame_line({
                        full = true,
                    })
                end, "查看当前行 blame")

                map("n", "<leader>hd", gitsigns.diffthis, "查看当前文件 diff")

                map("n", "<leader>hD", function()
                    gitsigns.diffthis("~")
                end, "查看相对 HEAD~ 的 diff")

                -- ================================================================
                -- Toggle
                -- ================================================================

                map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "切换当前行 blame")
                map("n", "<leader>tw", gitsigns.toggle_word_diff, "切换 word diff")
            end,
        },
    },
}
