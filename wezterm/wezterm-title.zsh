# 这个文件为 WezTerm 提供一套轻量 shell integration。
# 它会同时发送标题、当前目录、命令边界和 user vars，
# 让 WezTerm 可以更稳定地生成接近 iTerm2 的标题与状态体验。

# 如果你使用 oh-my-zsh，请把这项设置放在 oh-my-zsh 加载之前，
# 避免它的自动标题逻辑覆盖这里的 hook。
DISABLE_AUTO_TITLE="true"

__wezterm_osc() {
	local payload="$1"
	if [[ -n "${TMUX:-}" ]]; then
		printf '\033Ptmux;\033\033]%s\007\033\\' "$payload"
	else
		printf '\033]%s\007' "$payload"
	fi
}

__wezterm_set_title() {
	local title="$1"
	__wezterm_osc "2;${title}"
}

__wezterm_set_user_var() {
	local name="$1"
	local value="$2"
	local encoded=""

	if command -v base64 >/dev/null 2>&1; then
		encoded="$(printf '%s' "$value" | base64 | tr -d '\r\n')"
	fi

	__wezterm_osc "1337;SetUserVar=${name}=${encoded}"
}

__wezterm_mark_prompt_start() {
	__wezterm_osc "133;A"
}

__wezterm_mark_prompt_end() {
	__wezterm_osc "133;B"
}

__wezterm_mark_command_start() {
	__wezterm_osc "133;C"
}

__wezterm_mark_command_end() {
	local exit_code="$1"
	__wezterm_osc "133;D;${exit_code}"
}

__wezterm_title_cwd_name() {
	print -r -- "${PWD:t}"
}

__wezterm_title_command_name() {
	local cmdline="$1"
	local -a words
	local word
	local i=1

	words=("${(z)cmdline}")

	while ((i <= ${#words})); do
		word="${words[i]}"

		if [[ -z "$word" ]]; then
			((i++))
			continue
		fi

		case "$word" in
		sudo | command | builtin | noglob)
			((i++))
			continue
			;;
		env)
			((i++))
			while ((i <= ${#words})); do
				word="${words[i]}"
				if [[ "$word" == *=* ]]; then
					((i++))
				elif [[ "$word" == "-u" || "$word" == "--unset" ]]; then
					((i += 2))
				else
					break
				fi
			done
			continue
			;;
		esac

		if [[ "$word" == *=* ]]; then
			((i++))
			continue
		fi

		print -r -- "${word:t}"
		return
	done

	print -r -- "${ZSH_NAME:-zsh}"
}

__wezterm_title_format() {
	local cmd="$1"
	local cwd="$2"

	if [[ -n "$cmd" && -n "$cwd" ]]; then
		print -r -- "${cmd} · ${cwd}"
		return
	fi

	if [[ -n "$cmd" ]]; then
		print -r -- "$cmd"
		return
	fi

	if [[ -n "$cwd" ]]; then
		print -r -- "$cwd"
		return
	fi

	print -r -- "${ZSH_NAME:-zsh}"
}

__wezterm_emit_cwd() {
	local hostname
	hostname="${HOST:-$(hostname 2>/dev/null)}"
	if [[ -n "$hostname" ]]; then
		__wezterm_osc "7;file://${hostname}${PWD}"
	fi
}

__wezterm_emit_user_vars() {
	local cmd="$1"
	local cwd="$(__wezterm_title_cwd_name)"
	local shell_name="${ZSH_NAME:-${SHELL:t}}"
	local host_name="${HOST:-$(hostname 2>/dev/null)}"
	local user_name="${USER:-$(id -un 2>/dev/null)}"
	local last_status="${2:-0}"
	local in_tmux="0"

	if [[ -n "${TMUX:-}" ]]; then
		in_tmux="1"
	fi

	__wezterm_set_user_var "WEZTERM_PROG" "$cmd"
	__wezterm_set_user_var "WEZTERM_PROG_BASENAME" "$cmd"
	__wezterm_set_user_var "WEZTERM_CWD_BASENAME" "$cwd"
	__wezterm_set_user_var "WEZTERM_HOST" "$host_name"
	__wezterm_set_user_var "WEZTERM_USER" "$user_name"
	__wezterm_set_user_var "WEZTERM_SHELL" "$shell_name"
	__wezterm_set_user_var "WEZTERM_LAST_STATUS" "$last_status"
	__wezterm_set_user_var "WEZTERM_IN_TMUX" "$in_tmux"
}

__wezterm_preexec() {
	local cmd cwd title
	cmd="$(__wezterm_title_command_name "$1")"
	cwd="$(__wezterm_title_cwd_name)"
	title="$(__wezterm_title_format "$cmd" "$cwd")"

	__wezterm_set_title "$title"
	__wezterm_mark_command_start
	__wezterm_emit_user_vars "$cmd" "0"
}

__wezterm_precmd() {
	local exit_code="$?"
	local shell_name cwd title
	shell_name="${ZSH_NAME:-${SHELL:t}}"
	cwd="$(__wezterm_title_cwd_name)"
	title="$(__wezterm_title_format "$shell_name" "$cwd")"

	__wezterm_mark_command_end "$exit_code"
	__wezterm_emit_cwd
	__wezterm_emit_user_vars "$shell_name" "$exit_code"
	__wezterm_set_title "$title"
}

# prompt 显示前后打边界标记，便于 WezTerm 识别 prompt 区域。
__wezterm_precmd_prompt_start() {
	__wezterm_mark_prompt_start
}

__wezterm_preexec_prompt_end() {
	__wezterm_mark_prompt_end
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __wezterm_precmd_prompt_start
add-zsh-hook precmd __wezterm_precmd
add-zsh-hook preexec __wezterm_preexec_prompt_end
add-zsh-hook preexec __wezterm_preexec
