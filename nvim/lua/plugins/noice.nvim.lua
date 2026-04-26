-- ============================================================================
-- 命令行增强: folke/noice.nvim
-- ============================================================================
--
-- 问题说明:
--   • noice.nvim 会同时接管 cmdline 和 popupmenu
--   • 如果 cmdline_popup 和 popupmenu 都放在屏幕中间，命令补全时容易遮挡正文
--   • 这里将命令行移动到上方，并限制 popupmenu 高度，避免出现大面积遮挡
--
-- 配置效果:
--   ├─ 命令输入: 显示在顶部偏下位置
--   ├─ 命令补全: 显示在命令行下方
--   ├─ 遮挡减少: 不再把大弹窗放在屏幕正中央
--   └─ 稳定性: 保留 nui popupmenu，避免和 cmp / blink 的 cmdline 补全互相抢窗口
--

return {
    {
        "rcarriga/nvim-notify",

        lazy = true,

        opts = {
            timeout = 2500,
            render = "compact",
        },

        config = function(_, opts)
            local notify = require("notify")

            notify.setup(opts)
            vim.notify = notify
        end,
    },

    {
        "folke/noice.nvim",

        event = "VeryLazy",

        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },

        opts = {
            -- ====================================================================
            -- LSP 显示增强
            -- ====================================================================

            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },

            -- ====================================================================
            -- 命令行配置
            -- ====================================================================
            --
            -- 使用浮动命令行，但不要放在屏幕正中央。
            -- 放在上方可以避免输入命令时遮挡正文。

            cmdline = {
                enabled = true,
                view = "cmdline_popup",
            },

            -- ====================================================================
            -- 命令补全菜单
            -- ====================================================================
            --
            -- backend = "nui":
            --   使用 noice 自己的 popupmenu。
            --
            -- 注意:
            --   不建议这里切到 cmp / blink，除非你单独配置了 cmdline completion。
            --   否则容易出现两个补全系统互相抢窗口。

            popupmenu = {
                enabled = true,
                backend = "nui",
            },

            -- ====================================================================
            -- 视图配置
            -- ====================================================================

            views = {
                -- ================================================================
                -- 命令输入框
                -- ================================================================
                --
                -- 这里不要放在 row = "40%"。
                -- 中间位置会和 popupmenu 大面积重叠。
                --
                -- 推荐放在 row = 5 左右，类似 VSCode / JetBrains 的 command palette。

                cmdline_popup = {
                    position = {
                        row = 5,
                        col = "50%",
                    },

                    size = {
                        min_width = 60,
                        width = "60%",
                        height = "auto",
                    },

                    border = {
                        style = "rounded",
                        padding = {
                            0,
                            1,
                        },
                    },

                    win_options = {
                        winhighlight = {
                            Normal = "Normal",
                            FloatBorder = "NoiceCmdlinePopupBorder",
                        },
                    },
                },

                -- ================================================================
                -- 命令补全菜单
                -- ================================================================
                --
                -- 补全菜单放在命令行下方。
                -- 高度固定限制在 10 行，避免出现截图里那种巨大遮挡。

                popupmenu = {
                    relative = "editor",

                    position = {
                        row = 8,
                        col = "50%",
                    },

                    size = {
                        min_width = 60,
                        width = "60%",
                        height = "auto",
                        max_height = 10,
                    },

                    border = {
                        style = "rounded",
                        padding = {
                            0,
                            1,
                        },
                    },

                    win_options = {
                        winhighlight = {
                            Normal = "Normal",
                            FloatBorder = "NoiceCmdlinePopupBorder",
                            CursorLine = "Visual",
                            Search = "None",
                        },
                    },
                },
            },

            -- ====================================================================
            -- 预设配置
            -- ====================================================================

            presets = {
                -- 搜索也使用 noice 浮动窗口
                bottom_search = false,

                -- 不使用官方 command_palette 预设
                -- 因为这里已经手动控制 cmdline_popup / popupmenu 位置
                command_palette = false,

                -- 长消息进入 split，避免刷屏
                long_message_to_split = true,

                -- 不启用 inc-rename
                inc_rename = false,

                -- 不给 LSP 文档额外加边框
                lsp_doc_border = false,
            },
        },

        config = function(_, opts)
            vim.notify = require("notify")
            require("noice").setup(opts)
        end,
    },
}
