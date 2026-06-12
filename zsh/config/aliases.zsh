# aliases.zsh：通用别名（缺命令时自动跳过）

: ${eza_params:=""}

# 优先级：eza > eza-next > exa；非 eza 时包装成函数统一命名
typeset -g EZA_BIN
EZA_BIN="$(resolve_first_binary eza eza-next exa 2>/dev/null)"

if [[ -n "$EZA_BIN" && "$EZA_BIN" != "eza" ]]; then
    eza() { command "$EZA_BIN" "$@"; }
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

# bat 替代 cat（仅当存在时）
if command_exists bat; then
    alias cat='bat --paging=never --style=plain'
elif command_exists batcat; then
    alias cat='batcat --paging=never --style=plain'
fi

alias rm='rm -i'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

# NixOS 专属
if [[ "$ZSH_DISTRO" == "nixos" ]]; then
    alias rebuild='sudo nixos-rebuild switch --flake "${NIXOS_CONFIG_DIR:-$HOME/nixos}#"'
    alias testcfg='sudo nixos-rebuild test  --flake "${NIXOS_CONFIG_DIR:-$HOME/nixos}#"'
fi
