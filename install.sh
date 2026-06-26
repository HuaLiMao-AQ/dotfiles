#!/usr/bin/env bash
# install.sh：把仓库配置链接到 $HOME / $XDG_CONFIG_HOME

set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

DRY_RUN=0
FORCE=0
ONLY_ZSH=0
SKIP_CONFIG=0
NO_REBUILD=0
REBUILD_HOST=""

usage() {
	cat <<EOF
Usage: $0 [options]

Options:
  -n, --dry-run            只打印动作，不实际执行
  -f, --force              已存在的非软链文件不备份，直接覆盖
      --only-zsh           只安装 zsh 相关配置
      --skip-config        跳过 nvim / ghostty 等共享配置
      --no-rebuild         NixOS：跳过 nixos-rebuild，仅打印命令
      --rebuild-host=NAME  NixOS：指定 flake attribute（默认 \$(hostname)）
  -h, --help               显示本帮助
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	-n | --dry-run) DRY_RUN=1 ;;
	-f | --force) FORCE=1 ;;
	--only-zsh) ONLY_ZSH=1 ;;
	--skip-config) SKIP_CONFIG=1 ;;
	--no-rebuild) NO_REBUILD=1 ;;
	--rebuild-host=*) REBUILD_HOST="${1#*=}" ;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		printf 'unknown option: %s\n' "$1" >&2
		usage >&2
		exit 2
		;;
	esac
	shift
done

case "$(uname -s)" in
Darwin) PLATFORM="macos" ;;
Linux) PLATFORM="linux" ;;
*) PLATFORM="unknown" ;;
esac

DISTRO="unknown"
if [[ "$PLATFORM" == "linux" ]]; then
	if [[ -e /etc/NIXOS ]]; then
		DISTRO="nixos"
	elif [[ -e /etc/arch-release ]]; then
		DISTRO="arch"
	elif [[ -e /etc/fedora-release ]]; then
		DISTRO="fedora"
	elif [[ -e /etc/debian_version ]]; then
		DISTRO="debian"
	fi
fi

IS_NIXOS=0
[[ "$DISTRO" == "nixos" ]] && IS_NIXOS=1

c_blue=$'\e[34m'
c_green=$'\e[32m'
c_yellow=$'\e[33m'
c_red=$'\e[31m'
c_dim=$'\e[2m'
c_off=$'\e[0m'
if [[ ! -t 1 ]]; then
	c_blue=""
	c_green=""
	c_yellow=""
	c_red=""
	c_dim=""
	c_off=""
fi

info() { printf '%s•%s %s\n' "$c_blue" "$c_off" "$*"; }
ok() { printf '%s✓%s %s\n' "$c_green" "$c_off" "$*"; }
warn() { printf '%s!%s %s\n' "$c_yellow" "$c_off" "$*" >&2; }
err() { printf '%s✗%s %s\n' "$c_red" "$c_off" "$*" >&2; }

print_cmd() {
	local arg
	printf '%s$' "$c_dim"
	for arg in "$@"; do
		printf ' %q' "$arg"
	done
	printf '%s\n' "$c_off"
}

run() {
	if ((DRY_RUN)); then
		print_cmd "$@"
	else
		"$@"
	fi
}

backup_or_remove() {
	local dst="$1"

	if ((FORCE)); then
		warn "强制移除已存在 $dst"
		run rm -rf "$dst"
	else
		local backup="$dst.bak.$TIMESTAMP"
		warn "备份 $dst -> $backup"
		run mv "$dst" "$backup"
	fi
}

ensure_directory() {
	local dir="$1"

	if [[ -L "$dir" ]]; then
		local current
		current="$(readlink "$dir")"
		info "替换目录链接 $dir (was: $current)"
		run rm -f "$dir"
	elif [[ -e "$dir" && ! -d "$dir" ]]; then
		backup_or_remove "$dir"
	fi

	run mkdir -p "$dir"
}

link_path() {
	local src="$1"
	local dst="$2"
	local target="${3:-$src}"

	if [[ ! -e "$src" && ! -L "$src" ]]; then
		warn "跳过：源不存在 $src"
		return 0
	fi

	if [[ -L "$dst" ]]; then
		local current
		current="$(readlink "$dst")"
		if [[ "$current" == "$target" ]]; then
			ok "已就绪 $dst"
			return 0
		fi

		info "替换旧链接 $dst (was: $current)"
		run rm -f "$dst"
	elif [[ -e "$dst" ]]; then
		backup_or_remove "$dst"
	fi

	run mkdir -p "$(dirname -- "$dst")"
	run ln -s "$target" "$dst"
	ok "链接 $dst -> $target"
}

relative_path() {
	local src="$1"
	local base="$2"

	if realpath -m --relative-to="$base" "$src" >/dev/null 2>&1; then
		realpath -m --relative-to="$base" "$src"
		return 0
	fi

	err "当前 realpath 不支持 -m --relative-to，无法创建相对软链"
	return 1
}

link_relative() {
	local src="$1"
	local dst="$2"
	local dst_dir rel

	dst_dir="$(dirname -- "$dst")"
	rel="$(relative_path "$src" "$dst_dir")"
	link_path "$src" "$dst" "$rel"
}

install_zsh_files() {
	info "安装 zsh 配置"

	link_path "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
	[[ -e "$DOTFILES_DIR/zsh/zprofile" ]] && link_path "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
	ensure_directory "$XDG_CONFIG_HOME/zsh"
	link_path "$DOTFILES_DIR/zsh/config" "$XDG_CONFIG_HOME/zsh/config"
}

install_zsh_config_relative() {
	info "安装 zsh 配置"
	link_relative "$DOTFILES_DIR/zsh/config" "$XDG_CONFIG_HOME/zsh/config"
}

ensure_local_zsh() {
	local local_zsh="$DOTFILES_DIR/zsh/config/local.zsh"
	local local_example="$DOTFILES_DIR/zsh/config/local.zsh.example"

	if [[ ! -e "$local_zsh" && -e "$local_example" ]]; then
		info "生成本机私有配置 $local_zsh"
		run cp "$local_example" "$local_zsh"
	fi
}

install_shared_config() {
	((ONLY_ZSH || SKIP_CONFIG)) && return 0

	info "安装共享配置"
	[[ -d "$DOTFILES_DIR/nvim" ]] && link_path "$DOTFILES_DIR/nvim" "$XDG_CONFIG_HOME/nvim"
	[[ -d "$DOTFILES_DIR/ghostty" ]] && link_path "$DOTFILES_DIR/ghostty" "$XDG_CONFIG_HOME/ghostty"
}

install_shared_config_relative() {
	((ONLY_ZSH || SKIP_CONFIG)) && return 0

	info "安装共享配置"
	[[ -d "$DOTFILES_DIR/nvim" ]] && link_relative "$DOTFILES_DIR/nvim" "$XDG_CONFIG_HOME/nvim"
	[[ -d "$DOTFILES_DIR/ghostty" ]] && link_relative "$DOTFILES_DIR/ghostty" "$XDG_CONFIG_HOME/ghostty"
}

check_common_dependencies() {
	echo
	if ! command -v zsh >/dev/null 2>&1; then
		err "未找到 zsh，请先安装"
	elif ! command -v git >/dev/null 2>&1; then
		warn "未找到 git，zi 自举将被跳过；建议安装 git 后重启 shell"
	else
		ok "zsh / git 就位"
	fi

	if [[ "$PLATFORM" == "macos" ]] && ! command -v brew >/dev/null 2>&1; then
		warn "未检测到 Homebrew；如需使用 brew 路径请安装：https://brew.sh"
	fi
}

run_nixos_rebuild() {
	local flake_dir="$DOTFILES_DIR/nixos"
	local host="${REBUILD_HOST:-$(hostname)}"

	if [[ ! -e "$flake_dir/flake.nix" ]]; then
		err "未找到 $flake_dir/flake.nix，无法执行 nixos-rebuild"
		return 1
	fi

	info "NixOS：配置目录使用相对软链，系统状态交给 nixos-rebuild"
	install_zsh_config_relative
	ensure_local_zsh
	install_shared_config_relative

	info "Flake     : $flake_dir#$host"

	if ((NO_REBUILD)); then
		warn "--no-rebuild：仅打印 rebuild 命令"
		print_cmd sudo nixos-rebuild switch --flake "$flake_dir#$host"
		return 0
	fi

	if ! command -v nixos-rebuild >/dev/null 2>&1; then
		err "未找到 nixos-rebuild，确认当前是 NixOS"
		return 1
	fi

	run sudo nixos-rebuild switch --flake "$flake_dir#$host"
}

info "Dotfiles  : $DOTFILES_DIR"
info "Platform  : $PLATFORM / $DISTRO"
((DRY_RUN)) && warn "DRY-RUN 模式：不会修改任何文件"
echo

if ((IS_NIXOS)); then
	run_nixos_rebuild
	echo
	ok "完成。下一步："
	echo "  1) exec zsh                # 让 home-manager 注入的 .zshrc 生效"
	echo "  2) echo \$ZSH_DISTRO        # 应为 nixos"
	echo "  3) type zi                 # 应为 shell function"
	exit 0
fi

install_zsh_files
ensure_local_zsh
install_shared_config
check_common_dependencies

echo
ok "完成。下一步："
echo "  1) exec zsh                # 重新加载 zsh 配置"
echo "  2) echo \$ZSH_PLATFORM      # 验证平台探测"
echo "  3) type zi                 # 应为 shell function"
