import setuptools
from Cython.Build import cythonize

posit_ext = setuptools.Extension(
    'sfpy.posit', ['sfpy/posit.pyx'],
    include_dirs=['SoftPosit/source/include/'],
    extra_objects=['./SoftPosit/build/Linux-x86_64-GCC/softposit.a'],
    libraries=['m'],
)

float_ext = setuptools.Extension(
    'sfpy.float', ['sfpy/float.pyx'],
    include_dirs=['berkeley-softfloat-3/source/include/'],
    extra_objects=['./berkeley-softfloat-3/build/Linux-x86_64-GCC/softfloat.a'],
)

setuptools.setup(
    name='sfpy',
    version='0.1.0',
    description='softfloat and softposit in python',
    author='Bill Zorn',
    author_email='bill.zorn@gmail.com',
    url='https://github.com/billzorn/sfpy',
    packages=['sfpy'],
    ext_modules=cythonize([posit_ext, float_ext]),
)
