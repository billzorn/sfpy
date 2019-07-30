#!/bin/bash
set -e -x
cd /io/

# clear out existing module builds, which may be for the wrong system
make libclean
make clean
make distclean

#################################
# build softposit and softfloat #
#################################

rm -rf .cmake
/opt/python/cp37-cp37m/bin/python -m venv .cmake
source .cmake/bin/activate

pip install cmake cython

export CFLAGS="-static-libstdc++"
export CXXFLAGS="-static-libstdc++"
export CC="${GCC_PATH}/bin/gcc"
export CXX="${GCC_PATH}/bin/g++"

export PATH="${GCC_PATH}/bin:${PATH}"

make lib NPROCS=8
make cython

# cleanup
deactivate
rm -rf .cmake

####################
# build the wheels #
####################

rm -f wheelhouse/*.whl

for pybin in /opt/python/*/bin; do
    "${pybin}/pip" --no-cache-dir wheel . -w wheelhouse/
done

for whl in wheelhouse/*.whl; do
    auditwheel repair --plat "${1}" "${whl}" -w wheelhouse/
done

rm wheelhouse/*linux_x86_64.whl

# cleanup
make clean
make libclean
