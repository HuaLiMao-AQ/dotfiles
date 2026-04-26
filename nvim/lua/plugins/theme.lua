-- ============================================================================
-- 主题配置: Tokyonight 颜色方案
-- ============================================================================
--
-- 功能说明:
--   • 使用 Tokyonight 夜间模式作为编辑器主题
--   • 提供现代化的深色配色方案，减少眼睛疲劳
--   • 配置终端颜色支持，确保在各类程序中显示正确的颜色
--
-- Lazy.nvim 说明:
--   • colorscheme 建议设置 lazy = false，避免启动时主题加载过晚
--   • priority = 1000 确保主题优先于其他 UI 插件加载
--   • opts 会自动传给 require("tokyonight").setup(...)
--

return {
    {
        "folke/tokyonight.nvim",

        -- 主题必须尽早加载
        lazy = false,

        -- 提高加载优先级，避免其他插件先加载导致高亮异常
        priority = 1000,

        -- Tokyonight 配置
        opts = {
            style = "night",        -- 使用夜间模式
            transparent = false,    -- 禁用透明背景
            terminal_colors = true, -- 启用终端颜色支持
        },

        -- 插件加载完成后的配置
        config = function(_, opts)
            require("tokyonight").setup(opts)

            -- 应用主题
            vim.cmd.colorscheme("tokyonight")
        end,
    },
}
