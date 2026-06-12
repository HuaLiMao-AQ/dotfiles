# env.zsh：通用环境变量

export EDITOR=nvim
export VISUAL=nvim

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

export PASSWORD_STORE_DIR="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
export ZK_NOTEBOOK_DIR="${ZK_NOTEBOOK_DIR:-$HOME/notes}"
export DIRENV_LOG_FORMAT=""

# 终端颜色
export CLICOLOR=1
export LSCOLORS=ExGxFxdaCxDaDahbadeche
