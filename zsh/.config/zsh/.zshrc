# Коротко про конфиг:
# Ёр буллщит ай фак, порядок не тот
# Ты че долбаеб?

export ZDOTDIR=$HOME/.config/zsh

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

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-completions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "MichaelAquilina/zsh-you-should-use"
zsh_add_plugin "none9632/zsh-sudo"
# Theme install
zsh_add_plugin "sindresorhus/pure"

# zgen - plugin manager for plugins from oh-my-zsh
# Must be before configs and aliases
ZGEN_DIR=$ZDOTDIR/plugins/zgen/.zgen
zsh_add_plugin "tarjoilija/zgen"
source "$ZDOTDIR/plugins/zgen/zgen.zsh"

if ! zgen saved; then
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/colorize
  zgen oh-my-zsh plugins/web-search
  zgen oh-my-zsh plugins/colored-man-pages
  zgen save
fi

# что это ? 
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit

# Config
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
unsetopt beep notify
setopt magic_equal_subst
unsetopt multios
setopt interactive_comments
setopt auto_cd extended_glob no_match
setopt prompt_subst
stty stop undef		# Disable ctrl-s to freeze terminal.

# Aliases
alias ls='lsd'
alias cat='lolcat'
alias la='lsd -A'
alias l='lsd -lA'
alias tree='tree -a'
alias r='ranger'
alias grep='grep --color=auto'
alias v='nvim'

alias vcpp='clang++ -std=c++2b -stdlib=libc++ -fmodules -fbuiltin-module-map -fsanitize=address,leak,undefined'
alias vgpp='g++ -std=c++23 -Wall -Wextra -Wpedantic -Wconversion -fmodules-ts -fsanitize=address,leak,undefined'
alias vgc='gcc -std=c2x -Wall -Wextra -Wpedantic -Wconversion -fsanitize=address,leak,undefined'
alias vcc='clang -std=c2x -Wall -Wextra -Wpedantic -Wconversion -fsanitize=address,leak,undefined'

alias tk='cat $HOME/Token.txt | xclip -sel clip'
alias gs='git status'
alias gl='git log'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='tk; git push'
alias gu='git pull'

export VISUAL=nvim
export EDITOR=nvim

neofetch