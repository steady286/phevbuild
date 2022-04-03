# remember to "git submodule init; git submodule update"
mkdir -p build
rm -rf build/*
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_CJSON_TEST=OFF
make install
