# I, for one, welcome our new robot overlords
alias please='sudo $(fc -ln -1)'

# Don't close with Ctrl-D unless I mash it
export IGNOREEOF=2

# Search lab book for a phrase, run inside ~/dphil/exp
alias findmd='find . -name "*.md" | xargs ggrep --color=auto'

# Backup dphil folder
alias bupd='bup index ~/dphil && bup save -n dphil ~/dphil && echo'

# Print 256 terminal colours
colours () {
    curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
    printf '\n'
    for i in {0..255}; do printf '\e[38;5;%dm%3d ' $i $i; (((i+3) % 18)) || printf '\e[0m\n'; done
    printf '\n\n'
}

# typo-proof aliases
alias sl="ls"
alias gti="git"
alias dc="cd"

# ssh aliases
alias sshar="ssh linc3717@oscgate.arc.ox.ac.uk"
alias sshal="ssh linc3717@aleph.chem.ox.ac.uk"
alias sshdi="ssh linc3717@dirac.chem.ox.ac.uk"

# Venv functions
venv () {
    . $(fd -I -p 'bin/activate$') 2&>/dev/null ||
        . $(fd -I -p 'bin/activate$' ../) 2&>/dev/null ||
        . $(fd -I -p 'bin/activate$' ../../)  # don't suppress errors on the third go
}
dvenv() {
    deactivate
}

# Git autocompletion
source ~/.git-completion.bash

# Mac OS X - alias GNU utils, needed for git_branch function below
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Avoid $PATH chaos with tmux, see https://superuser.com/questions/544989
    if [ -f /etc/profile ]; then
        PATH=""
        source /etc/profile
    fi
    # GNU utils
    alias grep='ggrep --color=auto'
    alias sed='gsed'
    # ls colors - using GNU ls and GNU dircolors from brew:coreutils
    alias ls='gls --color=auto'
fi

# Set $PATH
PATH=$HOME/doi2bib:$HOME/qcnmr-tools:$HOME/ps-opt:$PATH

# Fancy terminal colors
git_branch() { 
    git symbolic-ref HEAD --short 2>/dev/null | sed -E 's/.+/ (&)/'
}
LIGHTCYAN='\[\033[38;5;45m\]'
WHITE='\[\033[38;5;15m\]'
LIGHTGREEN='\[\033[38;5;40m\]'
LIGHTYELLOW='\[\033[38;5;178m\]'
ORANGE='\[\033[38;5;202m\]'
RESET='\[$(tput sgr0)\]'

# For light mode
INDIGO='\[\033[38;5;20m\]'
BLACK='\[\033[38;5;0m\]'
GREEN='\[\033[38;5;22m\]'
DARKGOLD='\[\033[38;5;94m\]'
BRIGHTRED='\[\033[38;5;161m\]'

# For CARP-CRL
YELLOWORANGE='\[\033[38;5;179m\]'
BROWN='\[\033[38;5;130m\]'
LIGHTBLUE='\[\033[38;5;75m\]'
DARKBLUE='\[\033[38;5;26m\]'

# Mac OS X specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Add framework Python scripts to PATH
    # Note that Python scripts should no longer be installed to /usr/local/bin,
    # they should be installed to this directory. If they are in /usr/local/bin,
    # then they will shadow these, which is bad because those will be linked to
    # a nonexistent version of Python!
    PATH=$PATH:/Users/yongrenjie/Library/Python/3.8/bin
    # if this is in JupyterLab, cd to home directory!
    [ -n "$JUPYTER_SERVER_ROOT" ] && cd
    # aliases to start/stop JupyterLab launch service
    alias startjl='launchctl start jupyterlab_3.8'
    alias stopjl='launchctl stop jupyterlab_3.8'
    # Colours
    if [ -z "$JUPYTER_SERVER_ROOT" ] && [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
        # Dark mode.
        # We also check that $JUPYTER_SERVER_ROOT is not set, because I'm using a light theme in JupyterLab. It works nicely. :)
        export PS1="${LIGHTCYAN}\u${RESET}${WHITE}@${RESET}${LIGHTGREEN}\h:${RESET}${LIGHTYELLOW}\w${ORANGE}\$(git_branch)${RESET} ${LIGHTYELLOW}\$ ${RESET}"
        eval "$(gdircolors ~/.dircolors_dark)"
    else
        # Light mode
        export PS1="${INDIGO}\u${RESET}${BLACK}@${RESET}${GREEN}\h:${RESET}${DARKGOLD}\w${BRIGHTRED}\$(git_branch)${RESET} ${DARKGOLD}\$ ${RESET}"
        eval "$(gdircolors ~/.dircolors_light)"
    fi
    # SSH into WSL on CARP-CRL
    alias sshcarp="ssh yongrenjie@129.67.68.177 -p 2346"
    # SSH into PowerShell
    alias sshcarpwin="ssh jonathan.yong@129.67.68.177 -p 2345"
    # TopSpin path
    export TS=/opt/topspin4.0.9/exp/stan/nmr
    export TSDOC=/opt/topspin4.0.9/prog/docu/english/topspin/pdf
    # CodeMeter cleanup
    alias cleanuplog='sudo rm /Applications/Cm*.log'
    # Aliases for computational chemistry.
    alias mal='sudo sshfs -o allow_other,defer_permissions linc3717@aleph.chem.ox.ac.uk:/u/fd/linc3717 ~/mnt/aleph'
    alias umal='sudo umount ~/mnt/aleph'
    alias opal='open ~/mnt/aleph'
    alias cdal='cd ~/mnt/aleph'
    alias mdi='sudo sshfs -o allow_other,defer_permissions linc3717@dirac.chem.ox.ac.uk:/home/dirac/oxford/linc3717 ~/mnt/dirac'
    alias umdi='sudo umount ~/mnt/dirac'
    alias opdi='open ~/mnt/dirac'
    alias cddi='cd ~/mnt/dirac'
    alias rs='rm *.sh*'
    alias chemcraft='wine ~/.wine/drive_c/Chemcraft/Chemcraft.exe'
fi

cpoise() {
    cd ~/nmrpoise
    git checkout dev
    git fetch origin dev
    git reset --hard origin/dev
    rsync -av --progress $HOME/nmrpoise $WD --exclude .git --exclude tests
    cd -
}

# WSL-specific
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # CMD and PowerShell
    alias cmd='/mnt/c/Windows/System32/cmd.exe'
    alias pshell='/mnt/c/Windows/SysWOW64/WindowsPowerShell/v1.0/powershell.exe'
    # Colours
    export PS1="${YELLOWORANGE}\u${RESET}${WHITE}@${RESET}${BROWN}\h:${RESET}${LIGHTBLUE}\w${DARKBLUE}\$(git_branch)${RESET} ${LIGHTBLUE}\$ ${RESET}"
    # Windows home directory and desktop
    export WD='/mnt/c/Users/jonathan.yong/Desktop'
    export WH='/mnt/c/Users/jonathan.yong'
    # Copy poise to Windows desktop without .git
    # TopSpin directory
    export TS='/mnt/c/Bruker/topspin4.0.7/exp/stan/nmr'
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
    # Mount aleph.chem.ox.ac.uk - after mounting using SFTP
    alias mal="sudo mount -t drvfs E: /mnt/aleph"
    alias cdal="cd /mnt/aleph"
    alias umal="sudo umount /mnt/aleph"
    updateav600 () {
        rm -r $WH/noah-nmr/* $WH/ps-opt/*
        export curdir=$PWD
        cd ~/noah-nmr
        git checkout-index --prefix=$WH/noah-nmr/ -a
        cd ~/ps-opt
        git checkout-index --prefix=$WH/ps-opt/ -a
        cd /mnt/c
        cmd.exe /c robocopy C:\\Users\\jonathan.yong\\noah-nmr S:\\data\\mfgroup\\JonY\\noah-nmr /E
        cmd.exe /c robocopy C:\\Users\\jonathan.yong\\ps-opt S:\\data\\mfgroup\\JonY\\ps-opt /E
        cd $curdir
        unset curdir
    }
fi

# Bash completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Fzf settings
# Fix to allow fzf ** to work. See my comment at https://github.com/junegunn/fzf/issues/2035.
# PATH=$HOME/.fzf/bin:$PATH
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND="fd --type file"
export FZF_CTRL_T_COMMAND="fd --type file"
