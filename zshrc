# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zi 相关参数设置
readonly ZI_BIN=${HOME}/.config/zsh/zi/bin

# zi 加载
source $ZI_BIN/zi.zsh

# zi 插件
zi light z-shell/z-a-meta-plugins
zi light z-shell/z-a-bin-gem-node
zi light z-shell/z-a-patch-dl
#zi light zsh-users/zsh-syntax-highlighting
zi light Aloxaf/fzf-tab

zi snippet OMZL::git.zsh
#zi snippet OMZP::git.zsh
zi snippet OMZP::vscode
zi snippet OMZ::lib/key-bindings.zsh
zi snippet OMZP::sudo

#zi ice wait lucid has'eza' atinit'AUTOCD=1'
zi light z-shell/zsh-eza

zi light-mode for \
    @zsh-users+fast \
	@fuzzy @ext-git @annexes+

# 颜色更改
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche
FSYH_THEME=`fast-theme -s | awk 'NR==1 {print $4}'`
if [ $FSYH_THEME != "default" ] ;then
    fast-theme default > /dev/null 2>&1
fi

# zsh 主题
#zi ice pick"async.zsh" src"pure.zsh"
#zi light sindresorhus/pure
#PURE_PROMPT_SYMBOL="λ"
#zi light agnoster/agnoster-zsh-theme

zi ice depth=1; zi light romkatv/powerlevel10k

# 重命名
alias ls='eza $eza_params'
alias l='eza --git-ignore $eza_params'
alias ll='eza --all --header --long $eza_params'
alias llm='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree $eza_params'
alias tree='eza --tree $eza_params'

# 自定义环境变量

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
