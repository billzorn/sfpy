#!/bin/bash
set -e -x
cd /io/
ls

(cd SoftPosit/build/Linux-x86_64-GCC; make clean; make)
(cd berkeley-softfloat-3/build/Linux-x86_64-GCC; make clean; make)

for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" wheel . -w wheelhouse/
done

for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" -w wheelhouse/
done

rm wheelhouse/*linux_x86_64.whl

(cd SoftPosit/build/Linux-x86_64-GCC; make clean)
(cd berkeley-softfloat-3/build/Linux-x86_64-GCC; make clean)
