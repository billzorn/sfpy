import setuptools

with open('README.md', 'rt') as f:
    long_description = f.read()

posit_ext = setuptools.Extension(
    'sfpy.posit', ['sfpy/posit.c'],
    include_dirs=['SoftPosit/source/include/'],
    extra_objects=['SoftPosit/build/Linux-x86_64-GCC/softposit.a'],
    libraries=['m'],
)

float_ext = setuptools.Extension(
    'sfpy.float', ['sfpy/float.c'],
    include_dirs=['berkeley-softfloat-3/source/include/'],
    extra_objects=['berkeley-softfloat-3/build/Linux-x86_64-GCC/softfloat.a'],
)

setuptools.setup(
    name='sfpy',
    version='0.4.3',
    author='Bill Zorn',
    author_email='bill.zorn@gmail.com',
    url='https://github.com/billzorn/sfpy',
    description='softfloat and softposit in python',
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=['sfpy'],
    ext_modules=[posit_ext, float_ext],
    classifiers=[
        'Development Status :: 4 - Beta',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: Implementation :: CPython',
        'License :: OSI Approved :: MIT License',
    ]
)
