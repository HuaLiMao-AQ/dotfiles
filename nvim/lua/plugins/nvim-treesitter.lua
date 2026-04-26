-- ============================================================================
-- 语法解析增强: nvim-treesitter/nvim-treesitter
-- ============================================================================
--
-- 功能说明:
--   • 使用 Tree-sitter 提供更准确的语法高亮
--   • 支持代码缩进、语法结构识别和增量解析
--   • 为后续 textobjects、代码选择、结构跳转等功能提供基础
--   • 相比传统 regex 高亮，Tree-sitter 对复杂语言结构的识别更稳定
--
-- 配置效果:
--   ├─ 语法高亮: 更准确地识别函数、变量、类型、注释等结构
--   ├─ 代码缩进: 使用 Tree-sitter 辅助缩进
--   ├─ 语言覆盖: 覆盖 Go / Rust / C / C++ / Java / Kotlin / Python / Lua / Web 等常用语言
--   └─ 自动安装: 缺失 parser 时自动安装
--
-- 注意:
--   • 当前配置锁定 branch = "master"
--   • 原因是 nvim-treesitter main 分支存在较大不兼容重写
--   • 如果你后续升级到 main 分支，需要重新改写配置
--
-- Lazy.nvim 说明:
--   • build = ":TSUpdate" 表示更新插件后自动更新 parser
--   • event 表示打开文件时加载
--   • opts 会自动传给 require("nvim-treesitter.configs").setup(...)
--

return {
    {
        "nvim-treesitter/nvim-treesitter",

        -- 锁定传统配置分支
        branch = "master",

        -- 更新插件后同步更新 parser
        build = ":TSUpdate",

        -- 打开文件时加载
        event = {
            "BufReadPost",
            "BufNewFile",
        },

        opts = {
            -- ====================================================================
            -- Parser 安装列表
            -- ====================================================================
            --
            -- 这里按你的常用语言配置:
            --   • Go / Rust / C / C++ / Java / Kotlin
            --   • Python / Lua / Shell
            --   • HTML / CSS / JavaScript / TypeScript
            --   • JSON / YAML / TOML / Markdown
            --   • Dockerfile / Gitignore / Regex

            ensure_installed = {
                -- Neovim / Lua
                "lua",
                "luadoc",
                "vim",
                "vimdoc",

                -- Shell / 配置
                "bash",
                "json",
                "jsonc",
                "yaml",
                "toml",

                -- Go
                "go",
                "gomod",
                "gosum",
                "gowork",

                -- Rust
                "rust",

                -- C / C++
                "c",
                "cpp",

                -- JVM
                "java",
                "kotlin",

                -- Python
                "python",

                -- Web
                "html",
                "css",
                "javascript",
                "typescript",
                "tsx",

                -- 文档
                "markdown",
                "markdown_inline",

                -- 其他常用
                "dockerfile",
                "gitignore",
                "regex",
                "query",
            },

            -- 自动安装缺失 parser
            auto_install = true,

            -- 同步安装
            -- false 表示异步安装，不阻塞启动
            sync_install = false,

            -- ====================================================================
            -- 语法高亮
            -- ====================================================================

            highlight = {
                enable = true,

                -- 禁用指定语言的 Tree-sitter 高亮
                -- 如果某个语言高亮异常，可以在这里加进去
                disable = {},

                -- 不额外启用 regex 高亮
                -- true 可能导致重复高亮，除非某些语言确实需要
                additional_vim_regex_highlighting = false,
            },

            -- ====================================================================
            -- 缩进配置
            -- ====================================================================

            indent = {
                enable = true,

                -- 某些语言的 treesitter 缩进可能不稳定
                -- 后续如果遇到缩进异常，可以单独禁用
                disable = {},
            },

            -- ====================================================================
            -- 增量选择
            -- ====================================================================
            --
            -- 用 Tree-sitter 结构逐级扩大 / 缩小选择范围。
            -- 例如从变量名扩大到表达式、函数参数、函数体等。

            incremental_selection = {
                enable = true,

                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<BS>",
                },
            },
        },

        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
