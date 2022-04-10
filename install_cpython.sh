# Change version as appropriate
cd /Users/yongrenjie/progs/cpython/Python-3.10.2/
export LDFLAGS="-L/usr/local/opt/tcl-tk/lib -L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib -Wl,-rpath,/usr/local/opt/tcl-tk/lib -ltcl8.6 -ltk8.6"
export CPPFLAGS="-I/usr/local/opt/tcl-tk/include -I/usr/local/opt/openssl@1.1/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"
CXX=clang++ ./configure \
    --enable-framework \
    --enable-optimizations \
    --with-lto \
    --with-openssl='/usr/local/opt/openssl@1.1' \
    --with-ensurepip \
    --with-tcltk-includes="-I/usr/local/opt/tcl-tk/include" \
    --with-tcltk-libs="-L/usr/local/opt/tcl-tk/lib"
make -j
printf "CPython compilation done.\n\nUse\n\t\tmake install\nto make this the primary version of Python (overwrites python3 executable),\n or\n\t\tmake altinstall\nto make it an alternative version.\n\n"
