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

# Set $PATH
PATH=$HOME/doi2bib:$HOME/qcnmr-tools:$HOME/ps-opt:$PATH
export PATH

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
	alias sshal='ssh linc3717@aleph.chem.ox.ac.uk'
	alias opal='open ~/mnt/aleph'
	alias cdal='cd ~/mnt/aleph'
	alias mdi='sudo sshfs -o allow_other,defer_permissions linc3717@dirac.chem.ox.ac.uk:/home/dirac/oxford/linc3717 ~/mnt/dirac'
	alias umdi='sudo umount ~/mnt/dirac'
	alias sshdi='ssh linc3717@dirac.chem.ox.ac.uk'
	alias opdi='open ~/mnt/dirac'
	alias cddi='cd ~/mnt/dirac'
	alias rs='rm *.sh*'
	alias chemcraft='wine ~/.wine/drive_c/Chemcraft/Chemcraft.exe'
fi

# WSL-specific
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Windows home directory
    WINHOME='/mnt/c/Users/jonathan.yong'
    export WINHOME
    alias cdw='cd $WINHOME'
    # TopSpin directory
    TS=/mnt/C/opt/topspin4.0.7/exp/stan/nmr
    export TS
    # colourful ls
    alias ls="ls --color=auto"
    eval "$(dircolors ~/.dircolors)"
    # enable to show graphs on Windows
    export DISPLAY=localhost:0.0
fi
