# utils.zsh：通用工具函数

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

path_prepend_if_exists() {
    local dir="$1"
    if [[ -d "$dir" ]] && [[ ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$dir:$PATH"
    fi
}

path_append_if_exists() {
    local dir="$1"
    if [[ -d "$dir" ]] && [[ ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$PATH:$dir"
    fi
}

# 返回参数列表中第一个存在的可执行文件名
resolve_first_binary() {
    local candidate
    for candidate in "$@"; do
        if command_exists "$candidate"; then
            print -r -- "$candidate"
            return 0
        fi
    done
    return 1
}
