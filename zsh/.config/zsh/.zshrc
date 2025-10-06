# Коротко про конфиг:
# Ёр буллщит ай фак, порядок не тот
# Ты че долбаеб?

export ZDOTDIR=$HOME/.config/zsh
export PATH=$PATH:/home/$USER/.local/bin
export LESSHISTFILE=-

# Theme setup
# Must be before sourcing zsh-functions
if [ -d $ZDOTDIR/plugins/pure ]; then
    fpath+=($ZDOTDIR/plugins/pure)
    autoload -U promptinit; promptinit
    prompt pure
    RPROMPT='%F{white}%*'
fi

# Useful Functions
source "$ZDOTDIR/zsh-functions"

# что это ? 
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit
_comp_options+=(globdots)		# Include hidden files.

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-completions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "MichaelAquilina/zsh-you-should-use"
zsh_add_plugin "none9632/zsh-sudo"
zsh_add_plugin "Tarrasch/zsh-bd"
source "$ZDOTDIR/plugins/zsh-bd/bd.zsh"
# Theme install
zsh_add_plugin "sindresorhus/pure"

#----- было здесь

# Config
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

bindkey -v
bindkey '^n' history-search-forward
bindkey '^p' history-search-backward

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" 
zstyle ':completion:*' list-colors "ow=01;34:di=01;34"

unsetopt beep notify
setopt magic_equal_subst
unsetopt multios
setopt interactive_comments
setopt auto_cd extended_glob no_match
setopt prompt_subst
stty stop undef		# Disable ctrl-s to freeze terminal.

# from kitty config
#::  remap Ctrl+L to both scroll the current screen contents into the
#::  scrollback buffer and clear the screen, instead of just clearing
#::  the screen.
ctrl_l() {
    builtin print -rn -- $'\r\e[0J\e[H\e[22J' >"$TTY"
    builtin zle .reset-prompt
    builtin zle -R
}
zle -N ctrl_l
bindkey '^l' ctrl_l

# Aliases
alias ls='lsd'
alias cat='lolcat'
alias la='lsd -A'
alias l='lsd -lA'
alias tree='tree -a'
alias grep='grep --color=auto'
alias v='nvim'

alias vcpp='clang++ -std=c++2b -stdlib=libc++ -fmodules -fbuiltin-module-map -fsanitize=address,leak,undefined'
alias vgpp='g++ -std=c++23 -Wall -Wextra -Wpedantic -Wconversion -fmodules-ts -fsanitize=address,leak,undefined'
alias vgc='gcc -std=c2x -Wall -Wextra -Wpedantic -Wconversion -fsanitize=address,leak,undefined'
alias vcc='clang -std=c2x -Wall -Wextra -Wpedantic -Wconversion -fsanitize=address,leak,undefined'

tk() {
    if command -v wl-copy &> /dev/null && [ -n "$WAYLAND_DISPLAY" ]; then
        cat "$HOME/Token.txt" | wl-copy
    elif command -v xclip &> /dev/null ; then
        cat "$HOME/Token.txt" | xclip -sel clip
    else
        echo "Error: Either wl-copy nor xclip found"
        return 1
    fi
    echo "Token copied to clipboard"
}

alias gs='git status'
alias gl='git log'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='tk; git push'
alias gu='tk; git pull'

alias p='paru -Syyuu'
alias f='paru -Ss --bottomup'
alias i='paru -S'
alias d='paru -Rns'
alias q='paru -Qs'

alias mirrors="sudo reflector --verbose -c 'Russia,' -a 6 --sort rate --save /etc/pacman.d/mirrorlist"

# alias for yazi (file manager)
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

export VISUAL=nvim
export EDITOR=nvim

neofetch
