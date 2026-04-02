# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Make Homebrew available in shells launched by GUI apps/VS Code
# (use the path you provided; this is idempotent and only runs if brew exists)
if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

## Zi (plugin manager) and basic environment
# Ensure a default local bin exists and is defined
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

## powerlevel10k (p10k) prompt
# Use romkatv/powerlevel10k; load via zi. To create a config, run `p10k configure`
zi light romkatv/powerlevel10k
# If the user has a ~/.p10k.zsh (created by `p10k configure`), source it so the theme is applied
if [[ -r "${HOME}/.p10k.zsh" ]]; then
  source "${HOME}/.p10k.zsh"
fi

## aliases — ensure eza params has a sensible default if not set elsewhere
: ${eza_params:=""}
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

## zsh history (kept large as in original, but configurable if needed)
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

## plugins loaded via zi
zicompinit
zi light z-shell/z-a-meta-plugins
## Delay some non-critical plugins to reduce startup blocking
zi ice wait lucid atinit='zpcompinit'
zi ice wait lucid
zi light z-shell/z-a-bin-gem-node
zi ice wait lucid
zi light Aloxaf/fzf-tab
## zsh-eza: only load if `eza` binary is available to avoid errors; delay loading
if command -v eza >/dev/null 2>&1; then
  zi ice wait lucid
  zi light z-shell/zsh-eza
else
  # eza not installed yet; plugin will be skipped to avoid runtime errors.
  # Consider installing via Homebrew: `brew install eza`
  true
fi

zi snippet OMZL::git.zsh
zi snippet OMZP::git
zi snippet OMZP::sudo
zi snippet OMZP::vscode

## completion: load compinit once and use -u to skip insecure checks (avoids repeated warnings)
autoload -Uz compinit
compinit -u
zi cdreplay -q

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

## color
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche

# zsh-syntax-highlighting and zsh-autosuggestions
zi light zsh-users/zsh-syntax-highlighting
zi light zsh-users/zsh-autosuggestions

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Add Need Path
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
export PATH="${HOME}/.cargo/bin:$PATH"