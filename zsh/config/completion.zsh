# completion.zsh：补全配置

autoload -Uz compinit
compinit -u

# 回放 zi 缓存的 completion（仅当 zi 可用）
(( ${+functions[zi]} )) && zi cdreplay -q

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# fzf-tab：仅在已加载时配置（避免插件未就绪时报错）
if (( ${+functions[fzf-tab-complete]} )); then
    zstyle ':fzf-tab:*' use-fzf-default-opts yes
    zstyle ':completion:*:descriptions' format '[%d]'
fi

# autosuggest-accept：功能不存在时静默跳过
if [[ -n "${widgets[autosuggest-accept]+x}" ]] || zle -la autosuggest-accept 2>/dev/null; then
    bindkey '^ ' autosuggest-accept
fi
