export curdir=$PWD
cd $HOME/vim/src
git pull
make distclean
if [[ "$OSTYPE" == "darwin"* ]]; then
    # make doesn't know where to find the Homebrew installation, so must be manually specified.
    ./configure --enable-cscope --enable-python3interp --enable-perlinterp --enable-luainterp --with-lua-prefix=/usr/local --enable-rubyinterp --with-ruby-command=/usr/local/opt/ruby/bin/ruby LDFLAGS=-L/usr/local/opt/ruby/lib CPPFLAGS=-I/usr/local/opt/ruby/include
fi
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure --enable-cscope --enable-python3interp --enable-perlinterp --enable-luainterp --enable-rubyinterp
fi
make -j
make install
cd $curdir
unset curdir
