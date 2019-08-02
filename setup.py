import setuptools

with open('README.md', 'rt') as f:
    long_description = f.read()

posit_ext = setuptools.Extension(
    'sfpy.posit', ['sfpy/posit.c'],
    include_dirs=['sfpy/include/'],
    extra_objects=['sfpy/lib/softposit.a'],
    language='c',
)

float_ext = setuptools.Extension(
    'sfpy.float', ['sfpy/float.c'],
    include_dirs=['sfpy/include/'],
    extra_objects=['sfpy/lib/softfloat.a'],
    language='c',
)

setuptools.setup(
    name='sfpy',
    version='0.6.0',
    author='Bill Zorn',
    author_email='bill.zorn@gmail.com',
    url='https://github.com/billzorn/sfpy',
    description='softfloat and softposit in python',
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=['sfpy'],
    ext_modules=[posit_ext, float_ext],
    package_data={
        'sfpy': ['include/*.h', 'lib/*.a'],
    },
    classifiers=[
        'Development Status :: 4 - Beta',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'License :: OSI Approved :: MIT License',
    ]
)
