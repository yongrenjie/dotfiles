### General aliases and settings {{{1 

# I, for one, welcome our new robot overlords
alias please='sudo $(fc -ln -1)'
# Don't close with Ctrl-D unless I mash it
export IGNOREEOF=2
# Super lazy aliases
alias c="cd"
alias l="ls"
alias v="vim"
alias g="git"
alias n="nvim"
alias nv="nvim"
# typo-proof aliases
alias sl="ls"
alias gti="git"
alias dc="cd"
alias :e="vim"
alias vi="vim"   # It seems unlikely that I ever really want compatibility.
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
    export PATH=$PATH:$HOME/Library/Python/3.10/bin
    alias pip="python -m pip"
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
    # PATH="$HOME/.cabal/bin:$PATH"  # The next line already adds this
    [ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
    # Rust executables.
    PATH="$HOME/.cargo/bin:$PATH"
    # OCaml
    test -r "$HOME/.opam/opam-init/init.sh" && . "$HOME/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true
    # Python executables
    PATH=$PATH:$HOME/Library/Python/3.10/bin
    # Ruby executables (prefer brew over system install).
    PATH=$HOME/.gem/ruby/3.0.0/bin:/usr/local/lib/ruby/gems/3.0.0/bin:/usr/local/opt/ruby/bin:$PATH
    # MATLAB
    PATH=/Applications/MATLAB_R2023a.app/bin:$PATH
    ## Miscellaneous envvars and aliases {{{2
    # abbotsbury
    alias adr='abbot -d $HOME/refs'
    # Handbrake proofs
    hb () {
        OLD_PWD=$(pwd)
        cd ~/Downloads
        for fname in *.MOV; do
            HandBrakeCLI -i "${fname}" -o "${fname%.MOV}.mp4" --preset-import-file "/Volumes/JonY/poke_proofs/filter.json" -Z "proofs"
        done
        cd $OLD_PWD
    }
    # Write my thesis :-(
    alias vt='clear && cd ~/dphil/thesis && vim thesis.tex'
    alias nt='clear && cd ~/dphil/thesis && nvim thesis.tex'
    # Skimpdf tool
    alias skimpdf='/Applications/Skim.app/Contents/SharedSupport/skimpdf'
    # ssh into departmental computers
    alias bl='ssh -Y linc3717@bayleaf.chem.ox.ac.uk'
    # copy the .out files back (actually copies everything)
    alias scpout='rsync -r linc3717@bayleaf.chem.ox.ac.uk:~/matlab_nmr_jy/research/ ~/matlab_nmr_jy/research/'
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
    # Make matlab command default to no GUI
    alias matlab_gui='matlab'
    alias matlab='matlab -nodesktop -nosplash'
    # Make emacs colours behave
    alias emacs='TERM=xterm-256color emacs'
    # TopSpin path
    export ts=/opt/topspin4.1.3/exp/stan/nmr
    export tsdoc=/opt/topspin4.1.3/prog/docu/english/topspin/pdf
    # MATLAB root
    export MATLAB_ROOT=/Applications/MATLAB_R2021a.app/
    # python site-packages
    sp="$HOME/Library/Python/3.10/lib/python/site-packages"
    # aliases to start/stop JupyterLab launch service
    alias startjl='launchctl start jupyterlab_3.9'
    alias stopjl='launchctl stop jupyterlab_3.9'
    # Shortcut for cygnet
    cyg () {
        cygnet ~/papers/"$1" --nodebug
    }
    # Connect to Switch network
    switch () {
        networksetup -setairportnetwork en0 "switch_F24EA00100L" "$1" && open http://192.168.0.1/index.html
    }
    # vimtex test
    alias vtt='MYVIM="vim -T dumb --not-a-term --noplugin -n" make'
    ## DPhil file management {{{2
    # edit thesis
    alias et='cd ~/dphil/thesis; vim thesis.tex'
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
        export BAT_THEME="OneHalfDark"
    else
        export PS1="${LPURPLE}\u${LBLUE}@\h:${LPINK}\w${LRED}\$(git_branch) ${LORANGE}\$ ${RESET}"
        eval "$(gdircolors ~/.dircolors_light)"
        export BAT_THEME="OneHalfLight"
    fi
    ## }}}2
fi
### }}}1

### Turing macOS specific settings {{{1
if [[ "$OSTYPE" == "darwin"* && "$(whoami)" == "jyong" ]]; then
    # PATH etc
    test -r "${HOME}/.opam/opam-init/init.sh" && . "${HOME}/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true
    # Colours (always assume light mode) {{{2
    export PS1="${LPURPLE}pysm${LBLUE}@ati:${LPINK}\w${LRED}\$(git_branch) ${LORANGE}\$ ${RESET}"
    eval "$(gdircolors ~/.dircolors_light)"
    export BAT_THEME="OneHalfLight"
    ## }}}2
fi
### }}}1

### Linux-specific settings {{{1
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # General Linux-related stuff {{{2
    export EDITOR=vim
    # Colorscheme is always light, but can be changed via this variable
    export TERMCS=light
    if [[ "$TERMCS" == "dark" ]]; then
        export PS1="${PURPLE}\u${BLUE}@\h:${PINK}\w${RED}\$(git_branch) ${ORANGE}\$ ${RESET}"
        eval "$(dircolors ~/.dircolors_dark)"
    else
        export PS1="${LPURPLE}\u${LBLUE}@\h:${LPINK}\w${LRED}\$(git_branch) ${LORANGE}\$ ${RESET}"
        eval "$(dircolors ~/.dircolors_light)"
    fi
    # colourful ls
    alias ls="ls --color=auto"
    # }}}2

    if [[ $(hostname) == "dill"* ]]; then
        # Dill {{{2
        alias defcon="./configure --prefix=$HOME/progs"
        export PATH="/u/mf/linc3717/progs/bin:$PATH"  # My own compiled binaries
        # }}}2
    elif [[ $(hostname) == "bayleaf"* ]]; then
        # Bayleaf {{{2
        # Matlab requires an uncontaminated path (probably because of
        # Homebrew's glibc).
        alias matlab="PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin /usr/local/bin/matlab -nodesktop -nosplash"
        alias matlab_gui="PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin /usr/local/bin/matlab"
        alias defcon="./configure --prefix=$HOME/.local"
        export PKG_CONFIG_PATH=/usr/share/pkgconfig:$PKG_CONFIG_PATH
        export PATH="/u/mf/linc3717/.local/bin:$PATH"
        # Haskell binaries
        export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
        # Run matlab in batch mode on X file
        mrun () {
            PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin matlab -nodesktop -nosplash -nodesktop -nosplash -batch "$1()" | tee $1.out
        }
        # Homebrew setup
        export HOMEBREW_MAKE_JOBS=18
        export HOMEBREW_PREFIX="/home/bayleaf/mf/linc3717/.linuxbrew";
        export HOMEBREW_CELLAR="/home/bayleaf/mf/linc3717/.linuxbrew/Cellar";
        export HOMEBREW_REPOSITORY="/home/bayleaf/mf/linc3717/.linuxbrew";
        export HOMEBREW_SHELLENV_PREFIX="/home/bayleaf/mf/linc3717/.linuxbrew";
        export PATH="/home/bayleaf/mf/linc3717/.linuxbrew/bin:/home/bayleaf/mf/linc3717/.linuxbrew/sbin${PATH+:$PATH}";
        export MANPATH="/home/bayleaf/mf/linc3717/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
        export INFOPATH="/home/bayleaf/mf/linc3717/.linuxbrew/share/info:${INFOPATH:-}";
        # Let Homebrew use its own curl and git
        export HOMEBREW_DEVELOPER=1
        export HOMEBREW_CURL_PATH="$HOME/.local/bin/curl"
        export HOMEBREW_GIT_PATH="$HOME/.local/bin/git"
        # Tell Homebrew to use its own gcc after it gets installed
        # export HOMEBREW_CC=gcc
        # # Use Homebrew coreutils over system
        # export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
        # Bash completion from Homebrew
        [[ -r "$HOME/.linuxbrew/etc/profile.d/bash_completion.sh" ]] && . "$HOME/.linuxbrew/etc/profile.d/bash_completion.sh"
        # }}}2
    else
        # CARP-CRL WSL {{{2
        alias bl='ssh -Y linc3717@bayleaf.chem.ox.ac.uk'
        # CMD and PowerShell
        alias cmd='/mnt/c/Windows/System32/cmd.exe'
        alias pshell='/mnt/c/Windows/SysWOW64/WindowsPowerShell/v1.0/powershell.exe'
        # ghcup
        [ -f "/home/yongrenjie/.ghcup/env" ] && source "/home/yongrenjie/.ghcup/env"
        # Windows home directory and desktop
        export WD='/mnt/c/Users/jonathan.yong/Desktop'
        export WH='/mnt/c/Users/jonathan.yong'
        # TopSpin directory
        export ts='/mnt/c/Bruker/topspin4.0.7/exp/stan/nmr'
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
        # GHC
        export PATH=/opt/ghc/bin:$PATH
        export PATH=/home/yongrenjie/.local/bin:$PATH
    fi
        # Download POISE, dev version.
        getpoise() {
            cd ~/nmrpoise
            git checkout dev
            git fetch origin dev
            git reset --hard origin/dev
            # rsync -av --progress $HOME/nmrpoise $WD --exclude .git --exclude tests --exclude "nmrpoise-egg.info"
            cd -
        }
        # Download penguins, dev version
        getpenguins() {
            cd ~/penguins
            git checkout develop
            git fetch origin develop
            git reset --hard origin/develop
            cd -
        }
        # }}}2
    fi
# }}}1

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
