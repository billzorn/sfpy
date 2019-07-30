#!/bin/bash
set -e -x
cd /io/

# clear out existing lib builds, which may be for the wrong system
make libclean

rm -rf .cmake
/opt/python/cp37-cp37m/bin/python -m venv .cmake
source .cmake/bin/activate

pip install cmake cython

export CFLAGS="-static-libstdc++"
export CXXFLAGS="-static-libstdc++"
export CC="${GCC_PATH}/bin/gcc"
export CXX="${GCC_PATH}/bin/g++"

export PATH="${GCC_PATH}/bin:${PATH}"

which gcc

make lib
make cython

# cleanup
deactivate
rm -rf .cmake
