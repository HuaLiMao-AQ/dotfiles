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
                inc_rename = false,
                lsp_doc_border = false,
            },
        },
        config = function(_, opts)
            require("noice").setup(opts)
        end,
    },
}
