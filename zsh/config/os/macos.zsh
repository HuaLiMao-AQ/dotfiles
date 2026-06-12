# macOS 专属配置
# Homebrew 初始化已在 path.zsh 中处理；此处仅放 macOS 独有逻辑

# iTerm2 仅 macOS
if [[ "$ZSH_PLATFORM" == "macos" && -r "$HOME/.iterm2_shell_integration.zsh" ]]; then
	source "$HOME/.iterm2_shell_integration.zsh"
fi
