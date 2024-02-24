HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep notify
setopt magic_equal_subst
unsetopt multios
setopt interactive_comments

bindkey -v

export ZDOTDIR=$HOME/.config/zsh

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

export _JAVA_AWT_WM_NONREPARENTING=1

neofetch
# The following lines were added by compinstall
zstyle :compinstall filename '/home/xxx/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz promptinit
promptinit

prompt redhat

# Useful Functions
source "$ZDOTDIR/zsh-functions"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-completions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
