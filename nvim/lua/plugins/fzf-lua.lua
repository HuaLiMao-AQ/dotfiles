-- ============================================================================
-- 模糊搜索工具: ibhagwan/fzf-lua
-- ============================================================================
--
-- 功能说明:
--   • 使用 fzf-lua 提供文件搜索、全文搜索、buffer 搜索、历史文件搜索等功能
--   • 替代 Telescope，启动更轻，响应更快
--   • 支持 ripgrep 搜索项目内容
--   • 支持搜索 Neovim 命令、帮助文档、快捷键等
--
-- 配置效果:
--   ├─ 文件搜索: <leader>ff 搜索当前项目文件
--   ├─ 内容搜索: <leader>fg 使用 ripgrep 搜索项目文本
--   ├─ Buffer: <leader>fb 搜索已打开 buffer
--   ├─ 历史文件: <leader>fo 搜索最近打开文件
--   ├─ 命令搜索: <leader>fc 搜索 Neovim 命令
--   ├─ 快捷键搜索: <leader>fk 搜索当前 keymap
--   ├─ 帮助搜索: <leader>fh 搜索 help tags
--   └─ 恢复搜索: <leader>fr 恢复上一次 fzf-lua 窗口
--
-- 依赖说明:
--   • fzf: 底层模糊搜索工具
--   • ripgrep: 全文搜索工具，live_grep 依赖它
--   • nvim-web-devicons: 文件图标支持
--
-- Lazy.nvim 说明:
--   • cmd = "FzfLua" 表示执行 :FzfLua 时自动加载插件
--   • keys 表示按下指定快捷键时自动加载插件
--   • opts 会自动传给 require("fzf-lua").setup(...)
--

return {
    {
        "ibhagwan/fzf-lua",

        -- 命令触发加载
        cmd = {
            "FzfLua",
        },

        -- 图标依赖
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        -- 快捷键配置
        keys = {
            {
                "<leader>ff",
                function()
                    require("fzf-lua").files()
                end,
                desc = "搜索文件",
            },
            {
                "<leader>fg",
                function()
                    require("fzf-lua").live_grep()
                end,
                desc = "搜索文本",
            },
            {
                "<leader>fb",
                function()
                    require("fzf-lua").buffers()
                end,
                desc = "搜索 Buffer",
            },
            {
                "<leader>fo",
                function()
                    require("fzf-lua").oldfiles()
                end,
                desc = "搜索历史文件",
            },
            {
                "<leader>fc",
                function()
                    require("fzf-lua").commands()
                end,
                desc = "搜索命令",
            },
            {
                "<leader>fk",
                function()
                    require("fzf-lua").keymaps()
                end,
                desc = "搜索快捷键",
            },
            {
                "<leader>fh",
                function()
                    require("fzf-lua").help_tags()
                end,
                desc = "搜索帮助文档",
            },
            {
                "<leader>fr",
                function()
                    require("fzf-lua").resume()
                end,
                desc = "恢复上一次搜索",
            },
        },

        opts = {
            -- ====================================================================
            -- 全局窗口配置
            -- ====================================================================

            winopts = {
                -- 窗口高度
                height = 0.85,

                -- 窗口宽度
                width = 0.90,

                -- 居中显示
                row = 0.50,
                col = 0.50,

                -- 圆角边框
                border = "rounded",

                -- 预览窗口配置
                preview = {
                    -- flex 会根据窗口大小自动切换布局
                    layout = "flex",

                    -- 预览窗口宽度比例
                    horizontal = "right:50%",

                    -- 小窗口时改成下方预览
                    vertical = "down:45%",

                    -- 隐藏文件过长时的部分内容
                    scrollbar = "float",
                },
            },

            -- ====================================================================
            -- FZF 默认参数
            -- ====================================================================

            fzf_opts = {
                -- 使用反向布局，输入框在顶部
                ["--layout"] = "reverse",

                -- 显示边框
                ["--border"] = "none",

                -- 显示信息区域
                ["--info"] = "inline",
            },

            -- ====================================================================
            -- 文件搜索配置
            -- ====================================================================

            files = {
                prompt = "Files> ",

                -- 显示 Git 图标
                git_icons = true,

                -- 显示文件类型图标
                file_icons = true,

                -- 图标使用颜色
                color_icons = true,

                -- 默认忽略 .git
                fd_opts = table.concat({
                    "--color=never",
                    "--type f",
                    "--hidden",
                    "--follow",
                    "--exclude .git",
                }, " "),
            },

            -- ====================================================================
            -- 全文搜索配置
            -- ====================================================================

            grep = {
                prompt = "Rg> ",

                -- rg 默认参数
                rg_opts = table.concat({
                    "--column",
                    "--line-number",
                    "--no-heading",
                    "--color=always",
                    "--smart-case",
                    "--hidden",
                    "--glob !.git/*",
                }, " "),
            },

            -- ====================================================================
            -- Buffer 搜索配置
            -- ====================================================================

            buffers = {
                prompt = "Buffers> ",

                -- 显示文件名
                file_icons = true,

                -- 显示颜色
                color_icons = true,

                -- 按最近使用排序
                sort_lastused = true,
            },

            -- ====================================================================
            -- 历史文件配置
            -- ====================================================================

            oldfiles = {
                prompt = "Oldfiles> ",
            },
        },
    },
}
