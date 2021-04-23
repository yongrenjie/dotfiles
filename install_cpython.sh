# Change version as appropriate
cd /Users/yongrenjie/progs/cpython/Python-3.10.0a6/
export LDFLAGS="-L/usr/local/opt/tcl-tk/lib -L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib"
export CPPFLAGS="-I/usr/local/opt/tcl-tk/include -I/usr/local/opt/openssl@1.1/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"
CXX=clang++ ./configure \
    --enable-framework \
    --enable-optimizations \
    --with-lto \
    --with-openssl='/usr/local/opt/openssl@1.1' \
    --with-ensurepip
make -j
printf "CPython compilation done.\n\nUse\n\t\tmake install\nto make this the primary version of Python (overwrites python3 executable),\n or\n\t\tmake altinstall\nto make it an alternative version.\n\n"
