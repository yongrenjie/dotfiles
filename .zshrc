### General aliases and settings {{{1 

# I, for one, welcome our new robot overlords
alias please='sudo $(fc -ln -1)'
# Add git autocompletion to zsh
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.git-completion.bash
autoload -Uz compinit && compinit

setopt NO_CASE_GLOB # case-insensitive globbing
setopt IGNORE_EOF   # don't exit on Ctrl-D

# typo-proof aliases
alias l="ls"
alias sl="ls"
alias gti="git"
alias dc="cd"
# Print 256 terminal colours
colours () {
    curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
    printf '\n'
    for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
    printf '\n\n'
}
# Launch HTTP server on port 8000
alias http='python -m http.server'
# Intelligently launch venv
venv () {
    . $(fd -I -p 'bin/activate$') 2&>/dev/null ||
        . $(fd -I -p 'bin/activate$' ../) 2&>/dev/null ||
        . $(fd -I -p 'bin/activate$' ../../)  # don't suppress errors on the third go
}
alias dvenv="deactivate"
### }}}1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
