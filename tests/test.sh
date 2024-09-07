mkdir -p build && \
rlmake --dont-keep-rasls --dont-keep-rasl tests/Test.ref -o build/Test && \
build/Test
