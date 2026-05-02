-- ============================================================================
-- 背景透明: xiyaowong/transparent.nvim
-- ============================================================================
--
-- 功能说明:
--   • 一键切换 Neovim 背景透明，让终端壁纸透出
--   • 支持自定义哪些高亮组需要清除背景色
--   • 提供 TransparentEnable / TransparentDisable / TransparentToggle 命令
--
-- 配置效果:
--   ├─ 执行 :TransparentToggle 后 Normal、SignColumn、EndOfBuffer 等背景变为透明
--   ├─ 浮窗和弹出菜单保持不透明，保证可读性
--   └─ 终端壁纸透出，界面更通透
--
-- 快捷键:
--   • <leader>ut: 切换背景透明
--
-- Lazy.nvim 说明:
--   • event = "VimEnter" 表示 Neovim 启动后加载，确保高亮组已就绪
--   • opts 会自动传给 require("transparent").setup(...)
--

return {
    {
        "xiyaowong/transparent.nvim",
        event = "VimEnter",
        keys = {
            { "<leader>ut", "<cmd>TransparentToggle<CR>", desc = "切换背景透明" },
        },
        opts = {
            extra_groups = {
                "NormalFloat",
                "FloatBorder",
                "FloatTitle",
                "NvimTreeNormal",
                "NeoTreeNormal",
                "NeoTreeNormalNC",
                "NeoTreeFloatBorder",
                "NeoTreeEndOfBuffer",
                "SnacksDashboardNormal",
                "SnacksDashboardDesc",
                "SnacksDashboardFooter",
                "SnacksDashboardDir",
                "SnacksNotifierHistory",
            },
        },
    },
}
