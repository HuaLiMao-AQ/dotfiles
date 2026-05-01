-- ============================================================================
-- 命令行与消息 UI: folke/noice.nvim
-- ============================================================================
--
-- 功能说明:
--   • 美化 Neovim 命令行、消息、搜索提示和 LSP markdown 渲染
--   • 将通知交给 Snacks 后端显示，保持通知样式统一
--   • 为 inc-rename.nvim 启用专用命令行预设，保留实时重命名预览
--   • 使用 nui.nvim 作为 popupmenu 后端，保证命令行补全菜单稳定
--
-- 配置效果:
--   ├─ Cmdline: 使用居中的圆角浮窗显示命令行
--   ├─ Messages: 普通消息和告警通过 notify 视图展示
--   ├─ Notify: 使用 Snacks notify 后端，避免同时出现多套通知 UI
--   ├─ Popupmenu: 命令行补全菜单使用 nui 浮窗
--   └─ Rename: <leader>rn 触发 IncRename 时只显示 Noice 的重命名输入框
--
-- Lazy.nvim 说明:
--   • event = "VeryLazy" 表示启动完成后再加载
--   • dependencies 声明 noice 浮窗所需的 nui.nvim
--   • opts 会在 config 中传给 require("noice").setup(...)
--

return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            cmdline = {
                enabled = true,
                view = "cmdline_popup",
            },
            messages = {
                enabled = true,
                view = "notify",
                view_error = "notify",
                view_warn = "notify",
                view_history = "messages",
                view_search = "virtualtext",
            },
            notify = {
                enabled = true,
                view = "notify",
            },
            popupmenu = {
                enabled = true,
                backend = "nui",
            },
            views = {
                notify = {
                    backend = "snacks",
                    fallback = "mini",
                    format = "notify",
                    replace = false,
                    merge = false,
                },
                cmdline_popup = {
                    position = {
                        row = 4,
                        col = "50%",
                    },
                    size = {
                        min_width = 58,
                        width = "56%",
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
                            Normal = "NoiceCmdlinePopup",
                            FloatBorder = "NoiceCmdlinePopupBorder",
                            FloatTitle = "NoiceCmdlinePopupTitle",
                        },
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = 7,
                        col = "50%",
                    },
                    size = {
                        min_width = 58,
                        width = "56%",
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
                            Normal = "NoicePopupmenu",
                            FloatBorder = "NoicePopupmenuBorder",
                            CursorLine = "Visual",
                            Search = "None",
                        },
                    },
                },
            },
            presets = {
                bottom_search = false,
                command_palette = false,
                long_message_to_split = true,
                inc_rename = true,
                lsp_doc_border = false,
            },
        },
        config = function(_, opts)
            require("noice").setup(opts)
        end,
    },
}
