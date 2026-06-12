# NixOS 专属配置
# 不修改系统注入的 PATH，仅追加用户级变量

export NIXOS_CONFIG_DIR="${NIXOS_CONFIG_DIR:-$HOME/nixos}"
