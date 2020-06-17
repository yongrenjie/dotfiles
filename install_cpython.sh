# Compile CPython 3.8.3
cd $HOME/cpython/Python-3.8.3/
export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
cd Python-3.8.3/
CXX=clang++ ./configure \
    --enable-shared \
    --enable-optimizations \
    --with-lto \
    --with-openssl='/usr/local/opt/openssl@1.1' \
    --with-ensurepip
make -j
printf "CPython compilation done.\n\nUse\n\t\tmake install\nto make this the primary version of Python (overwrites python3 executable),\n or\n\t\tmake altinstall\nto make it an alternative version.\n\n"
