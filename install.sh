#!/usr/bin/env bash
# install.sh：把仓库内的配置软链到 $HOME / $XDG_CONFIG_HOME
# - 幂等：重复执行不报错
# - 安全：遇到非软链旧文件先备份到 .bak.<timestamp>
# - 跨平台：
#     macOS / 普通 Linux  → 直接软链
#     NixOS              → 跳过软链，由 home-manager 接管，执行 nixos-rebuild switch

set -euo pipefail

# ------------------------------------------------------------
# 路径与参数
# ------------------------------------------------------------

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TS="$(date +%Y%m%d-%H%M%S)"

DRY_RUN=0
FORCE=0
SKIP_CONFIG=0  # 跳过 nvim / ghostty 等共享配置
ONLY_ZSH=0
NO_REBUILD=0   # NixOS：跳过 nixos-rebuild，仅打印命令
REBUILD_HOST="" # NixOS flake attribute；为空时取 hostname

usage() {
	cat <<EOF
Usage: $0 [options]

Options:
  -n, --dry-run            只打印动作，不实际执行
  -f, --force              已存在的非软链文件不备份，直接覆盖
      --only-zsh           只链接 zsh 相关配置
      --skip-config        跳过 nvim / ghostty 等大块配置
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
		echo "unknown option: $1" >&2
		usage
		exit 2
		;;
	esac
	shift
done

# ------------------------------------------------------------
# 平台探测（与 zsh/config/detect.zsh 同口径）
# ------------------------------------------------------------

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

# ------------------------------------------------------------
# 输出 & 操作原语
# ------------------------------------------------------------

c_blue=$'\e[34m'
c_green=$'\e[32m'
c_yellow=$'\e[33m'
c_red=$'\e[31m'
c_dim=$'\e[2m'
c_off=$'\e[0m'
[[ -t 1 ]] || {
	c_blue=""
	c_green=""
	c_yellow=""
	c_red=""
	c_dim=""
	c_off=""
}

info() { printf '%s•%s %s\n' "$c_blue" "$c_off" "$*"; }
ok() { printf '%s✓%s %s\n' "$c_green" "$c_off" "$*"; }
warn() { printf '%s!%s %s\n' "$c_yellow" "$c_off" "$*" >&2; }
err() { printf '%s✗%s %s\n' "$c_red" "$c_off" "$*" >&2; }

run() {
	if ((DRY_RUN)); then
		printf '%s$ %s%s\n' "$c_dim" "$*" "$c_off"
	else
		"$@"
	fi
}

# 软链 src -> dst；处理 dst 已存在的所有情况
link() {
	local src="$1" dst="$2"

	if [[ ! -e "$src" && ! -L "$src" ]]; then
		warn "跳过：源不存在 $src"
		return 0
	fi

	if [[ -L "$dst" ]]; then
		local cur
		cur="$(readlink "$dst")"
		if [[ "$cur" == "$src" ]]; then
			ok "已就绪 $dst"
			return 0
		fi
		info "替换旧链接 $dst (was: $cur)"
		run rm -f "$dst"
	elif [[ -e "$dst" ]]; then
		if ((FORCE)); then
			warn "强制移除已存在 $dst"
			run rm -rf "$dst"
		else
			local backup="$dst.bak.$TS"
			warn "备份 $dst -> $backup"
			run mv "$dst" "$backup"
		fi
	fi

	run mkdir -p "$(dirname -- "$dst")"
	run ln -s "$src" "$dst"
	ok "链接 $dst -> $src"
}

# ------------------------------------------------------------
# NixOS：交由 home-manager / nixos-rebuild 接管
# ------------------------------------------------------------

run_nixos_rebuild() {
	local flake_dir="$DOTFILES_DIR/nixos"
	local host="${REBUILD_HOST:-$(hostname)}"

	if [[ ! -e "$flake_dir/flake.nix" ]]; then
		err "未找到 $flake_dir/flake.nix，无法执行 nixos-rebuild"
		return 1
	fi

	info "NixOS：软链由 home-manager 接管，跳过 install.sh 的 ln 步骤"
	info "Flake     : $flake_dir#$host"

	if ((NO_REBUILD)); then
		warn "--no-rebuild：仅打印 rebuild 命令"
		printf '%s$ sudo nixos-rebuild switch --flake %s#%s%s\n' \
			"$c_dim" "$flake_dir" "$host" "$c_off"
		return 0
	fi

	if ! command -v nixos-rebuild >/dev/null 2>&1; then
		err "未找到 nixos-rebuild，确认当前是 NixOS"
		return 1
	fi

	run sudo nixos-rebuild switch --flake "$flake_dir#$host"
}

# ------------------------------------------------------------
# 执行
# ------------------------------------------------------------

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

# --- zsh ---
link "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/zsh/config" "$XDG_CONFIG_HOME/zsh"

# 私有配置：从模板复制（不软链，便于本机修改且不会污染仓库）
local_zsh="$DOTFILES_DIR/zsh/config/local.zsh"
local_example="$DOTFILES_DIR/zsh/config/local.zsh.example"
if [[ ! -e "$local_zsh" && -e "$local_example" ]]; then
	info "生成本机私有配置 $local_zsh"
	run cp "$local_example" "$local_zsh"
fi

# --- 共享配置（可选）---
if ((!ONLY_ZSH)) && ((!SKIP_CONFIG)); then
	[[ -d "$DOTFILES_DIR/nvim" ]] && link "$DOTFILES_DIR/nvim" "$XDG_CONFIG_HOME/nvim"
	[[ -d "$DOTFILES_DIR/ghostty" ]] && link "$DOTFILES_DIR/ghostty" "$XDG_CONFIG_HOME/ghostty"
fi

# --- 前置依赖提示（仅提醒，不强制）---
echo
if ! command -v zsh >/dev/null 2>&1; then
	err "未找到 zsh，请先安装"
elif ! command -v git >/dev/null 2>&1; then
	warn "未找到 git，zi 自举将被跳过；建议安装 git 后重启 shell"
else
	ok "zsh / git 就位"
fi

case "$PLATFORM" in
macos)
	if ! command -v brew >/dev/null 2>&1; then
		warn "未检测到 Homebrew；如需使用 brew 路径请安装：https://brew.sh"
	fi
	;;
esac

# ------------------------------------------------------------
# 完成
# ------------------------------------------------------------

echo
ok "完成。下一步："
echo "  1) exec zsh                # 触发 zi 自举（首次约几十秒）"
echo "  2) echo \$ZSH_PLATFORM      # 验证平台探测"
echo "  3) type zi                 # 应为 shell function"
