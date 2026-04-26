-- ============================================================================
-- TODO 注释增强: folke/todo-comments.nvim
-- ============================================================================
--
-- 功能说明:
--   • 高亮代码中的 TODO / FIXME / HACK / BUG / NOTE 等特殊注释
--   • 支持通过 Trouble 查看项目中的 TODO 项
--   • 支持通过 fzf-lua 搜索 TODO 项
--   • 适合在项目中标记临时方案、待修复问题、危险代码和后续任务
--
-- 配置效果:
--   ├─ 高亮: 自动高亮 TODO / FIXME / BUG 等注释
--   ├─ 跳转: ]t / [t 在 TODO 注释之间跳转
--   ├─ Trouble: <leader>xt 使用 Trouble 查看 TODO 列表
--   ├─ FzfLua: <leader>ft 使用 fzf-lua 搜索 TODO
--   └─ 统一标记: 方便在大型项目里管理临时代码和后续任务
--
-- 常用标记:
--   • TODO: 后续需要完成
--   • FIX: 需要修复的问题
--   • FIXME: 需要修复的问题
--   • BUG: 明确的 Bug
--   • HACK: 临时方案
--   • WARN: 风险提醒
--   • NOTE: 说明备注
--   • PERF: 性能相关
--
-- Lazy.nvim 说明:
--   • event = { "BufReadPost", "BufNewFile" } 表示打开文件后加载
--   • dependencies 依赖 plenary.nvim
--   • cmd 提供 TodoTrouble / TodoFzfLua 等命令触发加载
--

return {
    {
        "folke/todo-comments.nvim",

        -- 打开文件后加载
        event = {
            "BufReadPost",
            "BufNewFile",
        },

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        cmd = {
            "TodoTrouble",
            "TodoFzfLua",
            "TodoQuickFix",
            "TodoLocList",
        },

        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "下一个 TODO 注释",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "上一个 TODO 注释",
            },
            {
                "<leader>xt",
                "<cmd>TodoTrouble<cr>",
                desc = "Trouble TODO 列表",
            },
            {
                "<leader>ft",
                "<cmd>TodoFzfLua<cr>",
                desc = "FzfLua TODO 搜索",
            },
        },

        opts = {
            -- ====================================================================
            -- 标记关键字配置
            -- ====================================================================

            keywords = {
                FIX = {
                    icon = " ",
                    color = "error",
                    alt = {
                        "FIXME",
                        "BUG",
                        "FIXIT",
                        "ISSUE",
                    },
                },

                TODO = {
                    icon = " ",
                    color = "info",
                },

                HACK = {
                    icon = " ",
                    color = "warning",
                },

                WARN = {
                    icon = " ",
                    color = "warning",
                    alt = {
                        "WARNING",
                        "XXX",
                    },
                },

                PERF = {
                    icon = " ",
                    color = "hint",
                    alt = {
                        "OPTIM",
                        "PERFORMANCE",
                        "OPTIMIZE",
                    },
                },

                NOTE = {
                    icon = " ",
                    color = "hint",
                    alt = {
                        "INFO",
                    },
                },
            },

            -- ====================================================================
            -- 高亮配置
            -- ====================================================================

            highlight = {
                -- 高亮整行中的关键字
                keyword = "wide",

                -- 注释前后额外匹配范围
                before = "",

                -- 关键字后面的内容不额外高亮
                after = "fg",

                -- 匹配模式
                pattern = [[.*<(KEYWORDS)\s*:]],

                -- 不高亮太长的行，避免大文件卡顿
                max_line_len = 400,

                -- 排除指定文件类型
                exclude = {},
            },

            -- ====================================================================
            -- 搜索配置
            -- ====================================================================

            search = {
                -- 使用 ripgrep 搜索
                command = "rg",

                -- ripgrep 参数
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },

                -- 搜索模式
                pattern = [[\b(KEYWORDS):]],
            },
        },
    },
}
