#!/usr/bin/env bash
files=(".vimrc" \
    ".vim" \
    ".nvim" \
    ".bash_profile" \
    ".dircolors_dark" \
    ".dircolors_light" \
    ".git-completion.bash" \
    ".tmux.conf" \
    ".bashrc" \
    ".rgignore" \
    ".config" \
    ".cabal-completion.bash" \
    ".ghci" \
    ".zshrc" \
    ".zsh" \
    ".utoprc" \
)
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
for f in ${files[@]}; do
    if [[ -L ${HOME}/${f} ]] || [[ ! -a ${HOME}/${f} ]] ; then
        rm ${HOME}/${f} 2&>/dev/null
        printf "symlink created:   %s\n" ${f}
        ln -s ${DOTFILES}/${f} ${HOME}/${f}
    else
        printf "non-symlink file was detected:   %s\n" ${f}
    fi
done

# One more line to ensure nvim config is correctly detected
if [[ ! -d ${HOME}/.config/nvim ]]; then
    ln -s ${HOME}/.nvim ${HOME}/.config/nvim
fi
