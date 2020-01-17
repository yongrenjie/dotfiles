# I, for one, welcome our new robot overlords
alias please='sudo $(fc -ln -1)'

# Don't close with Ctrl-D
set -o ignoreeof;

# tmux aliases
alias hiss='tmux split-window -v -p 30 python3'
alias ihiss='tmux split-window -v -p 30 ipython'

# typo-proof aliases
alias sl='ls'
alias gti='git'
alias dc='cd'

# ssh aliases
alias sshar='ssh linc3717@oscgate.arc.ox.ac.uk'
alias sshal='ssh linc3717@aleph.chem.ox.ac.uk'
alias sshdi='ssh linc3717@dirac.chem.ox.ac.uk'

# Set $PATH
PATH=$HOME/doi2bib:$HOME/qcnmr-tools:$HOME/ps-opt:$PATH

# Git autocompletion
source ~/.git-completion.bash

# Mac OS X - alias GNU utils, needed for git_branch function below
if [[ "$OSTYPE" == "darwin"* ]]; then
	# GNU utils
	alias grep='ggrep --color=auto'
    alias sed='gsed'
    # ls colors - using GNU ls and GNU dircolors from brew:coreutils
    alias ls='gls --color=auto'
    eval "$(gdircolors ~/.dircolors)"
fi

# Fancy terminal colors
git_branch() { 
    git symbolic-ref HEAD --short 2>/dev/null | sed 's/\(.\+\)/ (\1)/'
}
# https://gist.github.com/justintv/168835#gistcomment-2809621
LIGHTCYAN='\[\033[38;5;45m\]'
WHITE='\[\033[38;5;15m\]'
LIGHTGREEN='\[\033[38;5;40m\]'
LIGHTYELLOW='\[\033[38;5;178m\]'
ORANGE='\[\033[38;5;202m\]'
RESET='\[$(tput sgr0)\]'

YELLOWORANGE='\[\033[38;5;179m\]'
BROWN='\[\033[38;5;130m\]'
LIGHTBLUE='\[\033[38;5;75m\]'
DARKBLUE='\[\033[38;5;26m\]'

# Mac OS X specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Colours
    export PS1="${LIGHTCYAN}\u${RESET}${WHITE}@${RESET}${LIGHTGREEN}\h:${RESET}${LIGHTYELLOW}\w${ORANGE}\$(git_branch)${RESET} ${LIGHTYELLOW}\$ ${RESET}"
    # SSH into WSL on CARP-CRL
    alias sshcarp="ssh yongrenjie@129.67.68.177"
    # SSH into cmd
    alias sshcarpcmd="ssh jonathan.yong@129.67.68.177 -p 2222"
	# TopSpin path
	export TS=/opt/topspin4.0.7/exp/stan/nmr
	# CodeMeter cleanup
	alias cleanuplog='sudo rm /Applications/Cm*.log'
	# Switch between light and dark mode for TeXStudio.
	# Since I use vim for LaTeX now these are now pointless... but I'll just keep them anyway
	alias txslightmode='rm ~/.config/texstudio/stylesheet.qss; echo "TeXstudio: reverted to light mode."'
	alias txsdarkmode='cp ~/stylesheet.qss ~/.config/texstudio; echo "TeXstudio: dark mode turned on."'
	# Aliases for computational chemistry.
	alias orcam='open -a Google\ Chrome  ~/Documents/orca_manual_4_1_0.pdf'
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

# WSL-specific
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Colours
    export PS1="${YELLOWORANGE}\u${RESET}${WHITE}@${RESET}${BROWN}\h:${RESET}${LIGHTBLUE}\w${DARKBLUE}\$(git_branch)${RESET} ${LIGHTBLUE}\$ ${RESET}"
    # Windows home directory and desktop
    export WD='/mnt/c/Users/jonathan.yong/Desktop'
    export WH='/mnt/c/Users/jonathan.yong'
    # TopSpin directory
    export TS=/mnt/C/opt/topspin4.0.7/exp/stan/nmr
    # colourful ls
    alias ls="ls --color=auto"
    eval "$(dircolors ~/.dircolors)"
    # enable to show graphs on Windows
    export DISPLAY=localhost:0.0
    # TeX paths
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
fi
