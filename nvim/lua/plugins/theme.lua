-- ============================================================================
-- 主题与高亮: folke/tokyonight.nvim
-- ============================================================================
--
-- 功能说明:
--   • 使用 Tokyonight Night 作为 Neovim 主配色
--   • 保持编辑区不透明，降低长期阅读疲劳和背景干扰
--   • 统一 Snacks、Noice、bufferline、lualine 等界面组件的背景和边框色
--   • 弱化过亮、过重的标题和选中态，减少压迫感
--
-- 配置效果:
--   ├─ 编辑区: 使用 Tokyonight 默认背景，不启用透明
--   ├─ 浮窗: 使用 bg_float，边框使用低饱和蓝色混合色
--   ├─ Snacks: Dashboard / Input / Picker / Notifier 使用同一套高亮
--   ├─ Noice: 命令行和补全菜单与 Snacks 浮窗风格一致
--   └─ 选中态: 使用轻量背景混合色，不使用刺眼高亮
--
-- Lazy.nvim 说明:
--   • lazy = false 表示启动时立即加载主题
--   • priority = 1000 保证主题先于依赖高亮的 UI 插件生效
--   • config 中执行 colorscheme("tokyonight")
--

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

                hl.Normal = {
                    bg = c.bg,
                }
                hl.NormalNC = {
                    bg = c.bg,
                }
                hl.SignColumn = {
                    bg = c.bg,
                }
                hl.LineNr = {
                    bg = c.bg,
                }
                hl.CursorLineNr = {
                    bg = c.bg,
                }
                hl.EndOfBuffer = {
                    bg = c.bg,
                }
                hl.WinSeparator = {
                    fg = border,
                    bg = c.bg,
                }

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
                    fg = c.blue1,
                    bold = false,
                }
                hl.SnacksDashboardTitle = {
                    fg = c.blue1,
                    bold = false,
                }
                hl.SnacksDashboardDesc = {
                    fg = c.fg,
                }
                hl.SnacksDashboardIcon = {
                    fg = c.cyan,
                }
                hl.SnacksDashboardKey = {
                    fg = c.orange,
                    bold = false,
                }
                hl.SnacksDashboardFooter = {
                    fg = c.comment,
                }
                hl.SnacksDashboardDir = {
                    fg = c.blue5,
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
