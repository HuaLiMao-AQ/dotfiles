-- ============================================================================
-- nvim-mini/mini.icons 图标提供器
-- ============================================================================
-- 功能说明:
--   mini.icons 提供统一的文件类型、扩展名、目录和 LSP Kind 图标接口。
--   这里将它作为全局图标入口，并兼容模拟 nvim-web-devicons 接口。
--
-- 配置效果:
--   ├─ 按现有插件目录格式独立拆分为单文件
--   ├─ 启动时完成基础 setup，确保 MiniIcons 可用
--   ├─ 通过 mock_nvim_web_devicons() 兼容旧插件的 devicons 调用
--   └─ 作为现有 UI 插件的统一图标提供器
-- ============================================================================

return {
    "nvim-mini/mini.icons",
    version = false,

    config = function()
        require("mini.icons").setup()
        MiniIcons.mock_nvim_web_devicons()
    end,
}
