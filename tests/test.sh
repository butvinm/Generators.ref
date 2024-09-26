mkdir -p build && \
rlmake --dont-keep-rasls --tmp-dir build tests/Test.ref -o build/Test && \
build/Test
