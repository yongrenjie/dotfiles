#!/usr/bin/env bash

cd $HOME/progs/vim/src
git pull
make distclean
make clean

if [[ "$OSTYPE" == "darwin"* ]]; then
    # make doesn't know where to find the Homebrew installation, so must be manually specified.
    CPPFLAGS="-I$(brew --prefix ruby)/include -I/Library/Frameworks/Python.framework/Headers/" \
        LDFLAGS="-L$(brew --prefix ruby)/lib" \
        ./configure \
        --enable-cscope \
        --enable-python3interp \
        --enable-perlinterp \
        --enable-luainterp \
        --with-lua-prefix="/usr/local" \
        --enable-rubyinterp \
        --with-ruby-command="$(brew --prefix ruby)/bin/ruby" \
        --with-compiledby="$(whoami)"
    make -j
    sudo make install
fi
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # requires
    # sudo apt install lua5.3 liblua5.3-dev perl libperl-dev python3.9-dev
    # sudo apt install libx11-dev libxtst-dev libxt-dev libsm-dev libxpm-dev
    # (possibly amongst others)
    ./configure --enable-cscope --enable-python3interp=yes --enable-perlinterp=yes --enable-luainterp=yes --enable-rubyinterp --with-x
    make -j
    sudo make install
fi
