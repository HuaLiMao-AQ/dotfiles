# ================================
# 环境初始化
# ================================

# 仅在 macOS 下加载 Homebrew 环境，避免 Linux 误做 Homebrew 适配。
if [[ "$(uname -s)" == "Darwin" ]] && [ -x "/opt/homebrew/bin/brew" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ================================
# 插件管理器与基础目录
# ================================

# Zi 插件管理器目录和本地 bin 目录。
HOME_BIN="${HOME}/bin"
BIN_DIR="$HOME/.config/zsh/zi/bin"
HOME_DIR="$HOME/.config/zsh/zi"
typeset -A ZI
typeset -gx ZI[HOME_DIR]="${HOME_DIR}"
typeset -gx ZI[BIN_DIR]="${BIN_DIR}"
if [ ! -f "$BIN_DIR/zi.zsh" ]; then
	mkdir -p "${HOME_BIN}"
	mkdir -p "${BIN_DIR}"
	export ZI_HOME=$HOME_DIR
	sh -c "$(curl -fsSL get.zshell.dev)" --
fi
if [ -f "${BIN_DIR}/zi.zsh" ]; then
	source "${BIN_DIR}/zi.zsh"
fi

# ================================
# 启动阶段
# ================================

# 允许 instant prompt 在仍有第三方插件输出的场景下保持安静，
# 避免启动时反复弹出告警。
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Powerlevel10k instant prompt。
# 这段仍然需要尽量靠前，但会放在可能产生输出的自举逻辑之后。
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ================================
# 命令探测辅助
# ================================

command_exists() {
	command -v "$1" >/dev/null 2>&1
}

resolve_first_binary() {
	local candidate
	for candidate in "$@"; do
		if command_exists "$candidate"; then
			print -r -- "$candidate"
			return 0
		fi
	done
	return 1
}

# ================================
# 主题
# ================================

# 使用 Zi 加载 Powerlevel10k。
zi light romkatv/powerlevel10k

# 如果已经有 p10k 配置，则继续加载。
if [[ -r "${HOME}/.p10k.zsh" ]]; then
	source "${HOME}/.p10k.zsh"
fi

# ================================
# 别名
# ================================

# eza 参数默认值。
: ${eza_params:=""}

# 统一解析可用的 eza 二进制；如果主命令名不是 eza，就包装成 eza 函数，
# 这样后面的别名和补全仍然可以围绕统一命令名工作。
EZA_BIN="$(resolve_first_binary eza eza-next exa)"

if [[ -n "$EZA_BIN" ]] && [[ "$EZA_BIN" != "eza" ]]; then
	eza() {
		command "$EZA_BIN" "$@"
	}
fi

if [[ -n "$EZA_BIN" ]]; then
	alias ls='eza $eza_params'
	alias l='eza --git-ignore $eza_params'
	alias ll='eza --all --header --long $eza_params'
	alias llm='eza --all --header --long --sort=modified $eza_params'
	alias la='eza -lbhHigUmuSa'
	alias lx='eza -lbhHigUmuSa@'
	alias lt='eza --tree $eza_params'
	alias tree='eza --tree $eza_params'
fi

alias rm='rm -i'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

# ================================
# 历史记录
# ================================

# 保留较大的历史记录容量，便于长期检索。
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_BEEP

# ================================
# 插件
# ================================

# 先初始化 Zi 的补全体系，让后续插件都能正确挂载 completion。
zicompinit
zi light z-shell/z-a-meta-plugins

# 延迟加载部分非关键插件，减少启动阻塞。
zi ice wait lucid atinit='zpcompinit'
zi ice wait lucid
zi light z-shell/z-a-bin-gem-node

# 目录跳转增强：如果系统里装了 zoxide，就启用它。
if command_exists zoxide; then
	eval "$(zoxide init zsh)"
fi

# fzf-tab 依赖 compinit 之后的 completion 体系，放在补全链后面加载。
zi ice wait lucid
zi light Aloxaf/fzf-tab

# 只有在存在可用 eza 二进制时才加载 zsh-eza。
if [[ -n "$EZA_BIN" ]]; then
	zi ice wait lucid
	zi light z-shell/zsh-eza
else
	# eza 不存在时跳过插件，避免运行时报错。
	true
fi

# 别名提醒：输入完整命令时，提示你已经有更短的 alias 可用。
zi ice wait lucid
zi light MichaelAquilina/zsh-you-should-use

# 自动补全括号、引号等成对字符。
zi ice wait lucid
zi light hlissner/zsh-autopair

zi snippet OMZL::git.zsh
zi snippet OMZP::git
zi snippet OMZP::sudo
zi snippet OMZP::vscode

# ================================
# 补全
# ================================

# 只初始化一次 compinit，并在插件加载后回放 completion 定义。
autoload -Uz compinit
compinit -u
zi cdreplay -q

# 常用补全体验增强。
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# ================================
# 终端显示
# ================================

export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche

# 自动建议优先从历史记录和补全结果里生成。
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

# 自动建议应先于语法高亮加载；语法高亮尽量放在靠后位置。
zi light zsh-users/zsh-autosuggestions
zi light zsh-users/zsh-syntax-highlighting

# ================================
# 终端集成
# ================================

# iTerm2 shell integration 只在 macOS 下启用，Linux 不需要加载它。
if [[ "$(uname -s)" == "Darwin" ]] && [[ -r "${HOME}/.iterm2_shell_integration.zsh" ]]; then
	source "${HOME}/.iterm2_shell_integration.zsh"
fi

# WezTerm 标题 hook 在 macOS / Linux 共用，并统一从标准配置目录加载。
if [[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/wezterm/wezterm-title.zsh" ]]; then
	source "${XDG_CONFIG_HOME:-$HOME/.config}/wezterm/wezterm-title.zsh"
fi

# ================================
# PATH 扩展
# ================================

# 按目录存在情况追加 PATH，兼容 macOS / Linux 共用配置。
path_prepend_if_exists() {
	local dir="$1"
	if [[ -d "$dir" ]] && [[ ":$PATH:" != *":$dir:"* ]]; then
		export PATH="$dir:$PATH"
	fi
}

# Homebrew 扩展路径仅在 macOS 下追加。
if [[ "$(uname -s)" == "Darwin" ]]; then
	path_prepend_if_exists "/opt/homebrew/opt/mysql-client/bin"
	path_prepend_if_exists "/opt/homebrew/opt/rustup/bin"
fi

# 语言工具链与用户级 bin。
path_prepend_if_exists "${HOME}/.cargo/bin"
path_prepend_if_exists "${HOME}/.local/bin"
path_prepend_if_exists "${HOME}/bin"
