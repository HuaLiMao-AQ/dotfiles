# Zi
BIN_DIR="$HOME/.config/zsh/zi/bin"
HOME_DIR="$HOME/.config/zsh/zi"
typeset -A ZI
typeset -gx ZI[HOME_DIR]="${HOME_DIR}"
typeset -gx ZI[BIN_DIR]="${BIN_DIR}"
if [ ! -f "$BIN_DIR/zi.zsh" ]; then
  export ZI_HOME=$HOME_DIR
  sh -c "$(curl -fsSL get.zshell.dev)" --
fi
source $BIN_DIR/zi.zsh

# zsh theme
zi light-mode for compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload" \
  PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='>>'; PURE_PROMPT_VICMD_SYMBOL='<<'; \
  zstyle ':prompt:pure:prompt:success' color 'green' \
  zstyle ':prompt:pure:git:action' color 'yellow'; \
  zstyle ':prompt:pure:git:branch' color 'blue'; \
  zstyle ':prompt:pure:git:dirty' color 'red'; \
  zstyle ':prompt:pure:path' color 'cyan'" \
    sindresorhus/pure

# alias
alias ls='eza $eza_params'
alias l='eza --git-ignore $eza_params'
alias ll='eza --all --header --long $eza_params'
alias llm='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree $eza_params'
alias tree='eza --tree $eza_params'
alias rm='rm -i'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

# zsh history
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

# plugins
zicompinit

zi light z-shell/z-a-meta-plugins
zi light z-shell/z-a-bin-gem-node
zi light z-shell/z-a-patch-dl
zi light Aloxaf/fzf-tab
zi light z-shell/zsh-eza
zi light-mode for \
    @zsh-users+fast \
  	@fuzzy @ext-git @annexes+

zi ice wait lucid atinit='zpcompinit'
zi light zdharma/fast-syntax-highlighting

zi snippet OMZL::git.zsh
zi snippet OMZP::git
zi snippet OMZP::sudo
zi snippet OMZP::vscode

autoload -Uz compinit; compinit
zi cdreplay -q

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit

# color
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche
FSYH_THEME=`fast-theme -s | awk 'NR==1 {print $4}'`
if [ $FSYH_THEME != "default" ] ;then
    fast-theme default > /dev/null 2>&1
fi
