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

# Fancy terminal colors
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\033[38;5;45m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;40m\]\h:\[$(tput sgr0)\]\[\033[38;5;178m\]\w\[$(tput sgr0)\]\[\033[38;5;202m\]\$(parse_git_branch)\[$(tput sgr0)\] \[\033[38;5;178m\]\\$ \[$(tput sgr0)\]"

# Mac OS X specific
if [[ "$OSTYPE" == "darwin"* ]]; then
	# GNU grep
	alias grep='ggrep --color=auto'
	# TopSpin path
	TS=/opt/topspin4.0.7/exp/stan/nmr
	export TS
    # colourful ls
    export LSCOLORS=ExFxBxDxCxegedabagacad
    export CLICOLOR=1
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
    # Windows home directory and desktop
    WD='/mnt/c/Users/jonathan.yong/Desktop'
    WH='/mnt/c/Users/jonathan.yong'
    export WD
    export WH
    # TopSpin directory
    TS=/mnt/C/opt/topspin4.0.7/exp/stan/nmr
    export TS
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
    alias orca="/usr/local/bin/orca_4_2_1_linux_x86-64_shared_openmpi314/orca"
    # Running ORCA in parallel always requires absolute path, so no point adding to $PATH
    # export PATH=/usr/local/bin/orca_4_2_1_linux_x86-64_shared_openmpi314:$PATH
    # Mount aleph.chem.ox.ac.uk - after mounting using SFTP
    alias mal="sudo mount -t drvfs E: /mnt/aleph"
    alias cdal="cd /mnt/aleph"
    alias umal="sudo umount /mnt/aleph"
fi
