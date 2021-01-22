### General aliases and settings {{{1 

# I, for one, welcome our new robot overlords
alias please='sudo $(fc -ln -1)'
# Don't close with Ctrl-D unless I mash it
export IGNOREEOF=2
# typo-proof aliases
alias sl="ls"
alias gti="git"
alias dc="cd"
# Git autocompletion
source ~/.git-completion.bash
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

### Terminal color setup {{{1
git_branch() { 
    git symbolic-ref HEAD --short 2>/dev/null | sed -E 's/.+/ (&)/'
}
RESET='\[$(tput sgr0)\]'
# True color
if [[ $COLORTERM =~ ^(truecolor|24bit)$ ]]; then
    PURPLE='\[\033[38;2;168;131;247m\]'
    BLUE='\[\033[38;2;114;160;252m\]'
    ORANGE='\[\033[38;2;217;147;63m\]'
    PINK='\[\033[38;2;242;114;204m\]'
    RED='\[\033[38;2;227;104;98m\]'
    # For light mode
    LPURPLE='\[\033[38;2;159;10;209m\]'
    LBLUE='\[\033[38;2;53;85;230m\]'
    LORANGE='\[\033[38;2;186;107;13m\]'
    LPINK='\[\033[38;2;219;39;166m\]'
    LRED='\[\033[38;2;224;28;18m\]'
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

### macOS specific settings {{{1
if [[ "$OSTYPE" == "darwin"* ]]; then
    ## $PATH {{{2
    # Avoid $PATH chaos with tmux, see https://superuser.com/questions/544989
    if [ -f /etc/profile ]; then
        PATH=""
        source /etc/profile
    fi
    # Haskell executables
    PATH="$HOME/.cabal/bin:$PATH"
    [ -f "/Users/yongrenjie/.ghcup/env" ] && source "/Users/yongrenjie/.ghcup/env" # ghcup-env
    # Rust executables.
    PATH="$HOME/.cargo/bin:$PATH"
    # Python executables
    PATH=$PATH:/Users/yongrenjie/Library/Python/3.9/bin
    ## Miscellaneous envvars and aliases {{{2
    # Fzf into vim
    vf () {
        vfname=$(fzf)
        if [ ! -z $vfname ]; then
            vim $vfname
            unset vfname
        fi
    }
    # Skimpdf tool
    alias skimpdf='/Applications/Skim.app/Contents/SharedSupport/skimpdf'
    # Aliases for GNU utils, installed via Homebrew
    alias grep='ggrep --color=auto'
    alias sed='gsed'
    alias ls='gls --color=auto'
    # TopSpin path
    export ts=/opt/topspin4.1.0/exp/stan/nmr
    export tsdoc=/opt/topspin4.1.0/prog/docu/english/topspin/pdf
    # python site-packages
    sp="$HOME/Library/Python/3.9/lib/python/site-packages"
    # aliases to start/stop JupyterLab launch service
    alias startjl='launchctl start jupyterlab_3.9'
    alias stopjl='launchctl stop jupyterlab_3.9'
    # SSH into WSL on CARP-CRL (not working)
    # alias sshcarp="ssh yongrenjie@129.67.68.177 -p 2346"
    # SSH into PowerShell (not working)
    # alias sshcarpwin="ssh jonathan.yong@129.67.68.177 -p 2345"
    # Shortcut for cygnet
    cyg () {
        cygnet ~/papers/"$1"
    }
    ## DPhil file management {{{2
    # Default path to NMR data.
    export nmrd=/Volumes/JonY/dphil/expn/nmr
    # Backup dphil folder to SSD
    rsyncd () {
        rsync -av --info=progress2 --delete --exclude=expn ~/dphil /Volumes/JonY
        # we don't want --delete for the expn folder
        rsync -av --info=progress2 ~/dphil/expn /Volumes/JonY/dphil
    }
    # Set up Sphinx server and autobuild. These by default launch my DPhil lab book,
    # but the environment variable can be changed in order to launch a different
    # set of documentation.
    export SPHINX_TARGET=dphil
    dp1 () {
        if [[ "$SPHINX_TARGET" == "dphil" ]]; then
            python -m http.server 5555 -d ~/dphil/nbsphinx/dirhtml/
        elif [[ "$SPHINX_TARGET" == "penguins" ]]; then
            python -m http.server 5555 -d ~/penguins/docs/dirhtml
        else
            echo '$SPHINX_TARGET not set'
        fi
    }
    dp2 () {
        if [[ "$SPHINX_TARGET" == "dphil" ]]; then
            DP2_SPHINX_SOURCE=~/dphil/nbsphinx
            DP2_BUILD_FOLDER=dirhtml
        elif [[ "$SPHINX_TARGET" == "penguins" ]]; then
            DP2_SPHINX_SOURCE=~/penguins/docs
            DP2_BUILD_FOLDER=dirhtml
        else
            echo '$SPHINX_TARGET not set'
        fi
        while true; do
            # the sleep 0.5 is needed in order to get a nonzero exit code when mashing Ctrl-C.
            # entr by itself only returns nonzero if entr itself failed; it doesn't care what 
            # sphinx-build did or didn't do.
            sleep 0.5 && fd -e rst -e py . $DP2_SPHINX_SOURCE | entr -pzd sh -c "sphinx-build -a -E -b $DP2_BUILD_FOLDER $DP2_SPHINX_SOURCE $DP2_SPHINX_SOURCE/$DP2_BUILD_FOLDER"
            if [[ $? -ne 0 && $? -ne 2 ]]; then break; else continue; fi
        done
    }
    cabal-watch () {
        while true; do
            sleep 0.5 && fd -e hs . $CABAL_TOPLEVEL | entr -pzd sh -c "cabal build"
            if [[ $? -ne 0 && $? -ne 2 ]]; then break; else continue; fi
        done
    }
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
    # Colours
    if [[ "$TERMCS" == "dark" ]]; then
        export PS1="${PURPLE}\u${BLUE}@\h:${PINK}\w${RED}\$(git_branch) ${ORANGE}\$ ${RESET}"
        eval "$(gdircolors ~/.dircolors_dark)"
    else
        export PS1="${LPURPLE}\u${LBLUE}@\h:${LPINK}\w${LRED}\$(git_branch) ${LORANGE}\$ ${RESET}"
        eval "$(gdircolors ~/.dircolors_light)"
    fi
    ## }}}2
    ## Nix {{{2
    # added by Nix installer
    if [ -e /Users/yongrenjie/.nix-profile/etc/profile.d/nix.sh ]; then
        . /Users/yongrenjie/.nix-profile/etc/profile.d/nix.sh
    fi
    # }}}2
fi

### }}}1

### WSL-specific settings {{{1
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Colorscheme is always dark
    export TERMCS=dark
    # CMD and PowerShell
    alias cmd='/mnt/c/Windows/System32/cmd.exe'
    alias pshell='/mnt/c/Windows/SysWOW64/WindowsPowerShell/v1.0/powershell.exe'
    # Colours
    export PS1="${CARP_YELLOWORANGE}\u${RESET}${CARP_WHITE}@${RESET}${CARP_BROWN}\h:${RESET}${CARP_LIGHTBLUE}\w${CARP_DARKBLUE}\$(git_branch)${RESET} ${CARP_LIGHTBLUE}\$ ${RESET}"
    # Windows home directory and desktop
    export WD='/mnt/c/Users/jonathan.yong/Desktop'
    export WH='/mnt/c/Users/jonathan.yong'
    # TopSpin directory
    export ts='/mnt/c/Bruker/topspin4.0.7/exp/stan/nmr'
    # colourful ls
    alias ls="ls --color=auto"
    eval "$(dircolors ~/.dircolors_dark)"
    # enable to show graphs on Windows
    export DISPLAY=localhost:0.0
    # TeX paths. Note that tlmgr requires sudo, but sudo resets $PATH and so can't find tlmgr by itself.
    # the way to get around this is: sudo env "PATH=$PATH" tlmgr update --all
    export MANPATH=/usr/local/texlive/2019/texmf-dist/doc/man:$MANPATH
    export INFOPATH=/usr/local/texlive/2019/texmf-dist/doc/info:$INFOPATH
    export PATH=/usr/local/texlive/2019/bin/x86_64-linux:$PATH
    # OpenMPI 3.1.15 and ORCA 4.2.1
    export LD_LIBRARY_PATH=/usr/local/bin/orca_4_2_1_linux_x86-64_shared_openmpi314:/usr/local/lib:$LD_LIBRARY_PATH
    alias orca="/usr/local/bin/orca_4_2_1_linux_x86-64_shared_openmpi314/orca" # needs full path to run in parallel
fi
# }}}1

### fzf setup (needs to come at the bottom) {{{1
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND="fd --type file"
export FZF_CTRL_T_COMMAND="fd --type file"
export FZF_ALT_C_COMMAND="fd --type directory"
# }}}1
### direnv setup (needs to come at the bottom) {{{1
eval "$(direnv hook bash)"
# }}}1

# vim: foldmethod=marker
