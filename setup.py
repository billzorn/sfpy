from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

ext = Extension('posit', ['posit.pyx'],
    include_dirs=['SoftPosit/source/include/'],
    extra_objects=['./SoftPosit/build/Linux-x86_64-GCC/softposit.a'],
    libraries=['m'],
)

setup(
    name='sfpy',
    ext_modules=cythonize([ext]),
)
