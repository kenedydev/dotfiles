setopt autocd extendedglob nomatch
unsetopt beep notify

HISTFILE="$HOME/.histfile"
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit
compinit

bindkey -e
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word      # Ctrl+Backspace
bindkey '^[[2~' overwrite-mode       # Insert
bindkey '^[[3~' delete-char          # Delete
bindkey '^[[H' beginning-of-line     # Home
bindkey '^[[F' end-of-line           # End
bindkey '^[[5~' up-line-or-history   # Page Up
bindkey '^[[6~' down-line-or-history # Page Down

export EDITOR=nvim
export VISUAL=$EDITOR

typeset -U path
path=("$HOME/.local/bin" $path)
export PATH

alias ls='ls --color=auto'
alias startw='/usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland'

(($+commands[zoxide])) && eval "$(zoxide init zsh)"

autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz add-zle-hook-widget

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

typeset -g _pg_cat=$'\U0000eeed'
typeset -g _pg_dir=$'\uf07c'
typeset -g _pg_git=$'\uf418'
typeset -g _pg_ret=$'\U000f0311'
typeset -g _pg_host=$'\U000f07c0'

typeset -g _ps_git=''
typeset -g _ps_ret=''
typeset -g _ps_host=''

if [[ -n $SSH_CONNECTION || -n $SSH_CLIENT || -n $SSH_TTY ]]; then
	_ps_host="   %F{#ff2bd6}${_pg_host} ${HOST:l}%f"
fi

typeset -g _ps_marker='%F{#39ff14}❯%F{#22990c}▁%f '

typeset -g _prompt_full='
%F{#ff007f}${_pg_cat} %n%f${_ps_host}   %F{#ffffff}${_pg_dir} %~%f${_ps_git}${_ps_ret}
'"${_ps_marker}"

typeset -g _prompt_transient=$_ps_marker

_prompt_precmd() {
	local ret=$?

	vcs_info

	if [[ -n $vcs_info_msg_0_ ]]; then
		_ps_git="   %F{#f05033}${_pg_git} ${vcs_info_msg_0_}%f"
	else
		_ps_git=''
	fi

	if ((ret)); then
		_ps_ret="   %F{#ffc72c}${_pg_ret} ${ret}%f"
	else
		_ps_ret=''
	fi

	PROMPT=$_prompt_full
}

_prompt_line_finish() {
	PROMPT=$_prompt_transient
	zle .reset-prompt
}

add-zsh-hook precmd _prompt_precmd
add-zle-hook-widget line-finish _prompt_line_finish

setopt prompt_subst
PROMPT=$_prompt_full

[[ -r $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

for _plugin in zsh-autosuggestions zsh-syntax-highlighting; do
	_plugin_file="/usr/share/zsh/plugins/$_plugin/$_plugin.zsh"
	[[ -r $_plugin_file ]] && source $_plugin_file
done
unset _plugin _plugin_file
