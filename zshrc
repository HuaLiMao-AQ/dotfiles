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

# zsh 历史输入记录
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
