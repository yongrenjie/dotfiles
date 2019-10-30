# I, for one, welcome our new robot overlords
alias please='sudo $(fc -ln -1)'

# GNU grep
alias grep='ggrep --color=auto'

# Don't close with Ctrl-D
set -o ignoreeof;

# tmux aliases
alias hiss='tmux split-window -v -p 30 python3'
alias ihiss='tmux split-window -v -p 30 ipython'

# typo-proof aliases
alias sl='ls'
alias gti='git'

# Set $PATH
PATH=$HOME/doi2bib:$HOME/qcnmr-tools:$HOME/ps-opt:$PATH
export PATH
# TopSpin directory
TS=/opt/topspin4.0.7/exp/stan/nmr
export TS

# CodeMeter cleanup
alias cleanuplog='sudo rm /Applications/Cm*.log'

# Switch between light and dark mode for TeXStudio.
# Ironically if I learn to use vim for LaTeX maybe none of this is needed lol
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

# Fancy terminal colors
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\033[38;5;45m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;40m\]\h:\[$(tput sgr0)\]\[\033[38;5;178m\]\w\[$(tput sgr0)\]\[\033[38;5;202m\]\$(parse_git_branch)\[$(tput sgr0)\] \[\033[38;5;178m\]\\$ \[$(tput sgr0)\]"
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
