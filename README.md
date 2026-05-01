# Dotfiles

个人配置仓库，当前重点维护 Neovim 配置。Neovim 配置入口在 `nvim/`，插件配置按功能拆分在 `nvim/lua/plugins/`。

## Neovim 快捷键

说明：

- `<leader>` 是空格键。
- 部分快捷键由插件懒加载，首次触发时会自动加载对应插件。
- `which-key.nvim` 已启用，可以按 `<leader>?` 查看当前 buffer 可用快捷键。

### 基础窗口操作

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<C-h>` | Normal | 移动到左侧窗口 |
| `<C-j>` | Normal | 移动到下方窗口 |
| `<C-k>` | Normal | 移动到上方窗口 |
| `<C-l>` | Normal | 移动到右侧窗口 |
| `<C-Up>` | Normal | 减小窗口高度 |
| `<C-Down>` | Normal | 增加窗口高度 |
| `<C-Left>` | Normal | 减小窗口宽度 |
| `<C-Right>` | Normal | 增加窗口宽度 |
| `<` | Visual | 左移缩进并保持选择 |
| `>` | Visual | 右移缩进并保持选择 |

### Buffer 与文件管理

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<S-l>` | Normal | 切换到下一个 buffer |
| `<S-h>` | Normal | 切换到上一个 buffer |
| `-` | Normal | 打开当前文件所在目录 |
| `<leader>e` | Normal | 打开 Oil 浮动文件管理器 |
| `<leader>E` | Normal | 在当前窗口打开 Oil 文件管理器 |
| `<leader>l` | Normal | 打开/关闭 Neo-tree 文件树 |
| `<leader>o` | Normal | 在 Neo-tree 中定位当前文件 |

### 搜索与导航

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>ff` | Normal | 搜索文件 |
| `<leader>fg` | Normal | 搜索文本 |
| `<leader>fb` | Normal | 搜索 Buffer |
| `<leader>fo` | Normal | 搜索历史文件 |
| `<leader>fc` | Normal | 搜索命令 |
| `<leader>fk` | Normal | 搜索快捷键 |
| `<leader>fh` | Normal | 搜索帮助文档 |
| `<leader>fr` | Normal | 恢复上一次搜索 |
| `<leader>fy` | Normal | 搜索剪贴板历史 |
| `<leader>fY` | Normal | 搜索宏历史 |
| `<leader>?` | Normal | 查看当前 buffer 快捷键 |

### Git

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>gg` | Normal | 打开 LazyGit |
| `]c` | Normal | 下一个 Git hunk |
| `[c` | Normal | 上一个 Git hunk |
| `<leader>hs` | Normal/Visual | 暂存当前 hunk / 选中范围 |
| `<leader>hr` | Normal/Visual | 撤销当前 hunk / 选中范围 |
| `<leader>hS` | Normal | 暂存整个文件 |
| `<leader>hR` | Normal | 撤销整个文件 |
| `<leader>hp` | Normal | 预览当前 hunk |
| `<leader>hb` | Normal | 查看当前行 blame |
| `<leader>hd` | Normal | 查看当前文件 diff |
| `<leader>hD` | Normal | 查看当前文件与上游 diff |
| `<leader>tb` | Normal | 切换当前行 blame |
| `<leader>tw` | Normal | 切换 word diff |

### LSP、诊断与代码操作

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `gd` | Normal | 跳转到定义 |
| `gD` | Normal | 跳转到声明 |
| `gi` | Normal | 跳转到实现 |
| `gr` | Normal | 查找引用 |
| `K` | Normal | 查看文档 |
| `<leader>rn` | Normal | 增量重命名并预览 |
| `<leader>ca` | Normal | 代码操作 |
| `<leader>cd` | Normal | 查看当前行诊断 |
| `[d` | Normal | 上一个诊断 |
| `]d` | Normal | 下一个诊断 |
| `<leader>cf` | Normal/Visual | 格式化当前文件或选区 |

### 诊断、符号与 TODO

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>xx` | Normal | 项目诊断 |
| `<leader>xX` | Normal | 当前文件诊断 |
| `<leader>cs` | Normal | 当前文件符号 |
| `<leader>cl` | Normal | LSP 定义 / 引用 / 实现 |
| `<leader>xq` | Normal | Quickfix 列表 |
| `<leader>xl` | Normal | Location List |
| `]t` | Normal | 下一个 TODO 注释 |
| `[t` | Normal | 上一个 TODO 注释 |
| `<leader>xt` | Normal | Trouble TODO 列表 |
| `<leader>ft` | Normal | Snacks TODO 搜索 |

### 搜索替换与重构

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>sr` | Normal | 打开搜索替换 |
| `<leader>sR` | Normal | 搜索替换当前词 |
| `<leader>rn` | Normal | 重命名当前符号 |

### REST 请求

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>Rs` | Normal/Visual | 发送请求 |
| `<leader>Ra` | Normal/Visual | 发送全部请求 |
| `<leader>Rr` | Normal | 重放上次请求 |
| `<leader>Rb` | Normal | 打开请求草稿 |
| `<leader>Rc` | Normal | 复制为 cURL |
| `<leader>RC` | Normal | 从 cURL 创建请求 |
| `<leader>Re` | Normal | 选择请求环境 |

### Scratch 与临时记录

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>.` | Normal | 打开 Snacks 草稿 |
| `<leader>S` | Normal | 选择 Snacks 草稿 |

### 竞赛编程

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `<leader>cr` | Normal | 运行测试样例 |
| `<leader>cp` | Normal | 接收单个题目 |
| `<leader>cc` | Normal | 接收整场比赛 |
| `<leader>cA` | Normal | 添加测试样例 |
| `<leader>ce` | Normal | 编辑测试样例 |
| `<leader>cD` | Normal | 删除测试样例 |

### Oil 文件管理器内部快捷键

这些快捷键只在 Oil 目录 buffer 中生效。

| 快捷键 | 功能 |
| --- | --- |
| `g?` | 显示帮助 |
| `<CR>` | 打开文件 / 进入目录 |
| `<leader>v` | 垂直分屏打开 |
| `<leader>s` | 水平分屏打开 |
| `<leader>t` | 新 tab 打开 |
| `p` | 预览文件 |
| `q` | 关闭 Oil 窗口 |
| `R` | 刷新当前目录 |
| `-` | 返回上级目录 |
| `_` | 打开当前工作目录 |
| `` ` `` | 将当前目录设置为 cwd |
| `~` | 将当前目录设置为 tab cwd |
| `gs` | 修改排序方式 |
| `gx` | 使用系统默认程序打开文件 |
| `g.` | 显示 / 隐藏隐藏文件 |
| `g\` | 切换回收站视图 |
| `a` | 新建文件或目录 |
| `r` | 重命名当前条目 |
| `m` | 移动当前条目 |
| `d` | 删除当前条目 |

