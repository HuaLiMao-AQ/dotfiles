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
