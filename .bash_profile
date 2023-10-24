### General aliases and settings {{{1 

# I, for one, welcome our new robot overlords
alias please='sudo $(fc -ln -1)'
# Don't close with Ctrl-D unless I mash it
export IGNOREEOF=1
# Super lazy aliases
alias c="cd"
alias l="ls"
alias v="vim"
alias g="git"
alias n="nvim"
alias nn="nvim --"
alias nv="nvim"
alias t="tmux"
# typo-proof aliases
alias sl="ls"
alias gti="git"
alias dc="cd"
alias :e="vim"
alias vi="vim"   # It seems unlikely that I ever really want compatibility.
# Good practice
alias pip="python -m pip"
# Add some autocompletion to bash
source ~/.git-completion.bash
source ~/.cabal-completion.bash
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
# Vim plugin path
export vp=$HOME/.vim/pack/plugins/start
# Email for abbot
export ABBOT_EMAIL=`git config --get user.email`
# I'm lazy
alias de='dune exec --display=quiet -- '
alias dbw='dune build --watch'
### }}}1

### Terminal color setup {{{1
git_branch() { 
    git symbolic-ref HEAD --short 2>/dev/null | /usr/bin/sed -E 's/.+/ (&)/'
}
RESET='\[$(tput sgr0)\]'
# True color
# Note that the ANSI escape sequences themselves begin with \033 and end
# with m. The surrounding \[ and \] are specific to prompt variables, and
# are not needed when simply using bash's printf function (for example).
if [[ $COLORTERM =~ ^(truecolor|24bit)$ ]]; then
    PURPLE='\[\033[38;2;168;131;247m\]'
    BLUE='\[\033[38;2;114;160;252m\]'
    ORANGE='\[\033[38;2;217;147;63m\]'
    PINK='\[\033[38;2;242;114;204m\]'
    RED='\[\033[38;2;227;104;98m\]'
    # For light mode
    LPURPLE='\[\033[38;2;204;137;217m\]'
    LBLUE='\[\033[38;2;93;173;226m\]'
    LPINK='\[\033[38;2;232;121;197m\]'
    LRED='\[\033[38;2;235;108;127m\]'
    LORANGE='\[\033[38;2;237;164;69m\]'
else
    PURPLE='\[\033[38;5;135m\]'
    BLUE='\[\033[38;5;27m\]'
    ORANGE='\[\033[38;5;208m\]'
    PINK='\[\033[38;5;13m\]'
    RED='\[\033[38;5;203m\]'
    # Right now these are defined to be the same as the dark mode colours,
    # because I just can't be bothered right now.
    LPURPLE='\[\033[38;5;135m\]'
    LBLUE='\[\033[38;5;27m\]'
    LORANGE='\[\033[38;5;208m\]'
    LPINK='\[\033[38;5;13m\]'
    LRED='\[\033[38;5;203m\]'
fi
# For CARP-CRL
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    CARP_YELLOWORANGE='\[\033[38;5;179m\]'
    CARP_BROWN='\[\033[38;5;130m\]'
    CARP_LIGHTBLUE='\[\033[38;5;75m\]'
    CARP_DARKBLUE='\[\033[38;5;26m\]'
fi
### }}}1

# Reset $PATH to avoid chaos with tmux on macOS {{{1
# see https://superuser.com/questions/544989
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -f /etc/profile ]; then
        PATH=""
        source /etc/profile
    fi
fi
### }}}1

### Turing macOS Homebrew setup {{{1
if [[ "$OSTYPE" == "darwin"* && "$(whoami)" == "jyong" ]]; then
    # environment setup for various languages
    [ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env"
    source "${HOME}/.cargo/env"
    export PATH=${HOME}/Library/Python/3.10/bin:${PATH}
    export PATH=/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.2.0/bin:${PATH}
    alias bask="ssh uwls2817@login.baskerville.ac.uk"
    # Homebrew setup {{{2
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi
### }}}1

### macOS stuff (both home and Turing) {{{1
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Aliases for GNU utils, installed via Homebrew {{{2
    alias grep='ggrep --color=auto'
    alias sed='gsed'
    alias ls='gls --color=auto'
    alias r='R --no-save'
    alias R='R --no-save'
    ## Set terminal colors according to dark/light mode {{{2
    # In iTerm the $TERMCS envvar is tied to the iTerm profiles already.
    # We only need to account for other terminals. Here is Terminal.app:
    if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
        if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
            export TERMCS="dark"
        else
            export TERMCS="light"
        fi
    fi
    ## }}}2
    alias R='R --no-save'
    alias r='R --no-save'
    # fzf into (neo)vim
    vf () {
        vfname=$(fzf)
        if [ ! -z $vfname ]; then vim $vfname; unset vfname; fi
    }
    nf () {
        vfname=$(fzf)
        if [ ! -z $vfname ]; then nvim $vfname; unset vfname; fi
    }
fi
### }}}1

### Home macOS specific settings {{{1
if [[ "$OSTYPE" == "darwin"* && "$(hostname)" == "Empoleon"* ]]; then
    # Haskell executables
    [ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
    cabal-watch () {
        while true; do
            sleep 0.5 && fd -e hs . $CABAL_TOPLEVEL | entr -pzd sh -c "cabal build"
            if [[ $? -ne 0 && $? -ne 2 ]]; then break; else continue; fi
        done
    }
    # Rust executables.
    PATH="$HOME/.cargo/bin:$PATH"
    # Docker
    PATH="$HOME/.docker/bin:$PATH"
    # OCaml
    test -r "$HOME/.opam/opam-init/init.sh" && . "$HOME/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true
    # Python executables
    PATH=$PATH:$HOME/Library/Python/3.10/bin
    # Ruby executables (prefer brew over system install).
    PATH=$HOME/.gem/ruby/3.0.0/bin:/usr/local/lib/ruby/gems/3.0.0/bin:/usr/local/opt/ruby/bin:$PATH
    ## Miscellaneous envvars and aliases {{{2
    # Handbrake proofs
    hb () {
        OLD_PWD=$(pwd)
        cd ~/Downloads
        for fname in *.MOV; do
            HandBrakeCLI -i "${fname}" -o "${fname%.MOV}.mp4" --preset-import-file "/Volumes/PorygonZ/poke_proofs/filter.json" -Z "proofs"
        done
        cd $OLD_PWD
    }
    # VSCode
    PATH=$PATH:"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    # Inkscape export to same folder
    alias ipng='inkscape --export-type=png -D -d 600'
    alias ipdf='inkscape --export-type=pdf -D'
    # Inkscape export to Desktop
    ipngd () {
        for fname in "$@"; do
            if [ -f "$fname" ]; then
                inkscape --export-type=png -D -d 600 "$fname" --export-filename="$HOME/Desktop/$(basename -- ${fname%.svg}).png"
            fi
        done
    }
    ipdfd () {
        for fname in "$@"; do
            if [ -f "$fname" ]; then
                inkscape --export-type=pdf -D "$fname" --export-filename="$HOME/Desktop/$(basename -- ${fname%.svg}).pdf"
            fi
        done
    }
    # Make emacs colours behave. It's not as if I use emacs, but.
    alias emacs='TERM=xterm-256color emacs'
    # Connect to Switch network
    switch () {
        networksetup -setairportnetwork en0 "switch_F24EA00100L" "$1" && open http://192.168.0.1/index.html
    }
    # vimtex test
    alias vtt='MYVIM="vim -T dumb --not-a-term --noplugin -n" make'
    # Default path to NMR data.
    export nmrd=/Volumes/PorygonZ/dphil/expn/nmr
    # PS1 and other colorscheme-related stuff
    if [[ "$TERMCS" == "dark" ]]; then
        export PS1="${PURPLE}\u${BLUE}@\h:${PINK}\w${RED}\$(git_branch) ${ORANGE}\$ ${RESET}"
        eval "$(gdircolors ~/.dircolors_dark)"
        export BAT_THEME="OneHalfDark"
    else
        export PS1="${LPURPLE}\u${LBLUE}@\h:${LPINK}\w${LRED}\$(git_branch) ${LORANGE}\$ ${RESET}"
        eval "$(gdircolors ~/.dircolors_light)"
        export BAT_THEME="OneHalfLight"
    fi
fi
### }}}1

### Turing macOS specific settings {{{1
if [[ "$OSTYPE" == "darwin"* && "$(whoami)" == "jyong" ]]; then
    # OCaml executables
    test -r $HOME/.opam/opam-init/init.sh && . $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
    # Colours (always assume light mode) {{{2
    export PS1="${LPURPLE}pysm${LBLUE}@ati:${LPINK}\w${LRED}\$(git_branch) ${LORANGE}\$ ${RESET}"
    eval "$(gdircolors ~/.dircolors_light)"
    export BAT_THEME="OneHalfLight"
    ## }}}2
fi
### }}}1

### fzf setup (needs to come at the bottom) {{{1
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='(git status >/dev/null 2>&1 && fd --type file . $(git rev-parse --show-toplevel)) || fd -a --type file . $HOME
'
export FZF_CTRL_T_COMMAND="fd --type file . ~"
export FZF_ALT_C_COMMAND="fd --type directory . ~"
# }}}1

### direnv setup (needs to come at the bottom) {{{1
if [[ "$OSTYPE" == "darwin"* ]]; then
    eval "$(direnv hook bash)"
fi
# }}}1

# vim: foldmethod=marker
