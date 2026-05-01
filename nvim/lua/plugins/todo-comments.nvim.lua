-- ============================================================================
-- TODO 注释管理: folke/todo-comments.nvim
-- ============================================================================
--
-- 功能说明:
--   • 高亮 TODO / FIXME / HACK / WARN / PERF / NOTE 等代码注释
--   • 支持在 TODO 注释之间快速跳转
--   • 提供 Trouble、quickfix、location list 和 Snacks picker 查询入口
--   • 使用 rg 搜索项目中的 TODO 标记
--
-- 配置效果:
--   ├─ 高亮: 按关键字类型使用不同图标和颜色
--   ├─ 跳转: ]t / [t 在 TODO 注释之间移动
--   ├─ Trouble: <leader>xt 打开 TODO 列表
--   └─ Snacks: <leader>ft 或 :TodoSnacks 使用 Snacks picker 搜索 TODO
--
-- 注意:
--   • 这里会删除插件默认生成的 TodoFzfLua 和 TodoSnacks 命令
--   • 重新创建 TodoSnacks，确保后端固定使用 Snacks picker
--
-- Lazy.nvim 说明:
--   • event 表示打开文件后加载高亮能力
--   • cmd / keys 表示命令和快捷键也能触发懒加载
--   • dependencies 声明 todo-comments 所需的 plenary.nvim
--

return {
    {
        "folke/todo-comments.nvim",
        event = {
            "BufReadPost",
            "BufNewFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = {
            "TodoTrouble",
            "TodoSnacks",
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
                function()
                    Snacks.picker.pick("todo_comments")
                end,
                desc = "Snacks TODO 搜索",
            },
        },
        opts = {
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
            highlight = {
                keyword = "wide",
                before = "",
                after = "fg",
                pattern = [[.*<(KEYWORDS)\s*:]],
                max_line_len = 400,
                exclude = {},
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                },
                pattern = [[\b(KEYWORDS):]],
            },
        },
        config = function(_, opts)
            require("todo-comments").setup(opts)

            pcall(vim.api.nvim_del_user_command, table.concat({
                "Todo",
                "Fzf",
                "Lua",
            }))
            pcall(vim.api.nvim_del_user_command, "TodoSnacks")

            vim.api.nvim_create_user_command("TodoSnacks", function()
                Snacks.picker.pick("todo_comments")
            end, {
                desc = "Snacks TODO 搜索",
            })
        end,
    },
}
