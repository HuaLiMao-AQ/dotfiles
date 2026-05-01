return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night",
            transparent = false,
            terminal_colors = true,
            on_highlights = function(hl, c)
                local util = require("tokyonight.util")
                local border = util.blend_bg(c.blue1, 0.24)
                local accent = util.blend_bg(c.orange, 0.28)

                hl.NormalFloat = {
                    bg = c.bg_float,
                }
                hl.FloatBorder = {
                    fg = border,
                    bg = c.bg_float,
                }
                hl.FloatTitle = {
                    fg = c.blue1,
                    bg = c.bg_float,
                    bold = false,
                }

                hl.SnacksDashboardNormal = {
                    bg = c.bg,
                }
                hl.SnacksDashboardHeader = {
                    fg = c.blue,
                    bold = true,
                }
                hl.SnacksDashboardDesc = {
                    fg = c.fg_dark,
                }
                hl.SnacksDashboardIcon = {
                    fg = c.cyan,
                }
                hl.SnacksDashboardKey = {
                    fg = c.orange,
                }
                hl.SnacksDashboardFooter = {
                    fg = c.comment,
                }
                hl.SnacksDashboardDir = {
                    fg = c.comment,
                }

                hl.SnacksInputBorder = {
                    fg = accent,
                    bg = c.bg_float,
                }
                hl.SnacksInputTitle = {
                    fg = c.orange,
                    bg = c.bg_float,
                }
                hl.SnacksPickerInputBorder = {
                    fg = border,
                    bg = c.bg_float,
                }
                hl.SnacksPickerInputTitle = {
                    fg = c.blue1,
                    bg = c.bg_float,
                }
                hl.SnacksPickerBoxTitle = {
                    fg = c.blue1,
                    bg = c.bg_float,
                }
                hl.SnacksNotifierHistory = {
                    bg = c.bg_float,
                }

                hl.NoiceCmdlinePopup = {
                    bg = c.bg_float,
                }
                hl.NoiceCmdlinePopupBorder = {
                    fg = accent,
                    bg = c.bg_float,
                }
                hl.NoiceCmdlinePopupTitle = {
                    fg = c.orange,
                    bg = c.bg_float,
                }
                hl.NoicePopupmenu = {
                    bg = c.bg_float,
                }
                hl.NoicePopupmenuBorder = {
                    fg = border,
                    bg = c.bg_float,
                }
                hl.NoicePopupmenuSelected = {
                    bg = util.blend_bg(c.blue1, 0.14),
                    bold = false,
                }
            end,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight")
        end,
    },
}
