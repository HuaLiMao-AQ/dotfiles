-- ============================================================================
-- Neovim 主页美化: folke/snacks.nvim dashboard
-- ============================================================================
--
-- 功能说明:
--   • 使用 snacks.nvim 的 dashboard 模块美化 Neovim 启动首页
--   • 提供 Logo、快捷入口、最近文件、最近项目和启动耗时显示
--   • 与 lazy.nvim / fzf-lua / tokyonight 配合较好
--   • 只启用 dashboard，不启用 snacks.nvim 的其他模块，避免和现有插件冲突
--
-- 配置效果:
--   ├─ Header: 显示自定义 Neovim ASCII Logo
--   ├─ Keys: 显示常用入口，例如搜索文件、搜索文本、最近文件、配置目录
--   ├─ Recent: 显示最近打开文件
--   ├─ Projects: 显示最近项目
--   ├─ Startup: 显示 lazy.nvim 启动耗时
--   └─ Picker: 默认调用 fzf-lua，和当前搜索方案保持一致
--
-- 快捷键:
--   • f: 搜索文件
--   • g: 搜索文本
--   • r: 最近文件
--   • c: 打开 Neovim 配置目录
--   • l: 打开 Lazy.nvim
--   • m: 打开 Mason
--   • q: 退出 Neovim
--
-- Lazy.nvim 说明:
--   • priority = 1000 表示尽早 setup snacks.nvim
--   • lazy = false 表示启动时加载 dashboard
--   • opts.dashboard.enabled = true 表示只启用 dashboard 模块
--

return {
    {
        "folke/snacks.nvim",

        -- 尽早加载
        -- dashboard 是启动页插件，应该在 Neovim 启动阶段可用
        priority = 1000,

        -- 不懒加载
        -- 否则 nvim 空启动时可能无法显示主页
        lazy = false,

        opts = {
            -- ====================================================================
            -- Dashboard 配置
            -- ====================================================================

            dashboard = {
                -- 启用 dashboard 模块
                enabled = true,

                -- 首页宽度
                width = 60,

                -- nil 表示垂直居中
                row = nil,

                -- nil 表示水平居中
                col = nil,

                -- 多列 pane 之间的间隔
                pane_gap = 4,

                -- ==================================================================
                -- 预设内容
                -- ==================================================================

                preset = {
                    -- Header Logo
                    -- 注意:
                    --   • 这里用纯文本 ASCII，稳定不依赖图片支持
                    --   • 如果终端字体不等宽，Logo 可能会轻微错位
                    header = [[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝

      ShanCircle Development Environment
                    ]],

                    -- 首页快捷入口
                    keys = {
                        {
                            icon = " ",
                            key = "f",
                            desc = "Find File",
                            action = ":lua Snacks.dashboard.pick('files')",
                        },

                        {
                            icon = " ",
                            key = "g",
                            desc = "Find Text",
                            action = ":lua Snacks.dashboard.pick('live_grep')",
                        },

                        {
                            icon = " ",
                            key = "r",
                            desc = "Recent Files",
                            action = ":lua Snacks.dashboard.pick('oldfiles')",
                        },

                        {
                            icon = " ",
                            key = "c",
                            desc = "Config",
                            action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
                        },

                        {
                            icon = "󰒲 ",
                            key = "l",
                            desc = "Lazy",
                            action = ":Lazy",
                            enabled = package.loaded.lazy ~= nil,
                        },

                        {
                            icon = " Mason",
                            key = "m",
                            desc = "Mason",
                            action = ":Mason",
                        },

                        {
                            icon = " ",
                            key = "q",
                            desc = "Quit",
                            action = ":qa",
                        },
                    },
                },

                -- ==================================================================
                -- 页面布局
                -- ==================================================================
                --
                -- section 可用项:
                --   • header: Logo
                --   • keys: 快捷入口
                --   • recent_files: 最近文件
                --   • projects: 最近项目
                --   • startup: 启动耗时

                sections = {
                    {
                        section = "header",
                    },

                    {
                        section = "keys",
                        gap = 1,
                        padding = 1,
                    },

                    {
                        pane = 2,
                        icon = " ",
                        title = "Recent Files",
                        section = "recent_files",
                        indent = 2,
                        padding = 1,
                    },

                    {
                        pane = 2,
                        icon = " ",
                        title = "Projects",
                        section = "projects",
                        indent = 2,
                        padding = 1,
                    },

                    {
                        section = "startup",
                    },
                },
            },
        },
    },
}
