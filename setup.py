from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

posit_ext = Extension(
    'sfpy.posit', ['sfpy/posit.pyx'],
    include_dirs=['SoftPosit/source/include/'],
    extra_objects=['./SoftPosit/build/Linux-x86_64-GCC/softposit.a'],
    libraries=['m'],
)

setup(
    name='sfpy',
    version='0.1.0',
    description='softfloat and softposit in python',
    author='Bill Zorn',
    author_email='bill.zorn@gmail.com',
    url='https://github.com/billzorn/sfpy',
    packages=['sfpy'],
    ext_modules=cythonize([posit_ext]),
)
