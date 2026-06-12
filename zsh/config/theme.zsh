# theme.zsh：Powerlevel10k

# 仅在 zi 可用时加载主题
if ((${+functions[zi]})); then
	zi light romkatv/powerlevel10k
fi

if [[ -r "${ZSH_CONFIG_HOME:-$HOME/.config/zsh}/theme/p10k.zsh" ]]; then
	source "${ZSH_CONFIG_HOME:-$HOME/.config/zsh}/theme/p10k.zsh"
fi
