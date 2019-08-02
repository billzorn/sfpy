## Building (on Linux x86_64, with bash)

### Python Environment
First, make sure a virtual environment is set up with Cython and twine:

```
$ python -m venv .env
$ source .env/bin/activate
(.env) $ pip install --upgrade -r requirements.txt
[...]
(.env) $
```

### Building the C libraries
The Makefile includes targets for all steps of the build process.

First, compile the C libraries (remember to check out the submodules,
and make the necessary changes to their build files).

```
$ make lib
[...]
$
```

This will build the submodules, and copy all of the files necessary for
the source distribution to the appropriate locations to build sfpy.

### Cython extensions
Next, compile the Cython to distributable C:

```
(.env) $ make cython
(.env) $
```

### Building locally
The extension modules can be built in place in the usual way:

```
(.env) $ make inplace
[...]
(.env) $
```

A local wheel (compatible with the python version installed in the virtual
environment) can be built with the following:

```
(.env) $ make wheel
[...]
(.env) $
```

The local wheel will be created in the `dist/` directory. This is the recommended
way to install the package when building it from source locally:

```
$ pip install dist/sfpy*.whl
[...]
$ python
>>> from sfpy import *
>>> Posit8(1.3)
Posit8(1.3125)
>>>
```

The package can also be distributed in source form, including the cythonized
C and the compiled static libraries:

```
(.env) $ make sdist
[...]
(.env) $
```

Installing this package requires a linux environment compatible with the
static libraries and a C compiler, but not Cython.

Finally, the makefile includes several commands for cleaning up after building
and distribution; `make libclean` cleans the builds of the C libraries,
`make clean` cleans up the files Python creates during distribution,
and `make distclean` deletes the files that are copied over from the build
C libraries for inclusion in a source package release.

`make allclean` runs all of these cleaning procedures at the same time.

### Building manylinux wheels for distribution
Widely compatible linux wheels can be built with the help of PyPA's manylinux
docker image. This requires that Docker is installed, and that the host can pull
the proper docker image. The process should also work on customized manylinux
images, such as my modifications to allow use of GCC 8.3 and mingw-w64 6.0.0.

To make sure the build process works, try the following:

```
$ docker run -u $(id -u) --rm -v `pwd`:/io quay.io/pypa/manylinux1_x86_64 /io/docker-build-libs.sh
[...]
$
```

To build the manylinux wheels, run:

```
$ docker run -u $(id -u) --rm -v `pwd`:/io -ti billzorn/manylinux-gcc8:1.3 /io/docker-build-wheels.sh manylinux1_x86_64
[...]
$
```

This will create a set of wheel (.whl) files in the `wheelhouse/` directory.

The tagged image `-ti billzorn/manylinux-gcc8:1.3` can be replaced with another suitable manylinux image.

The argument at the end, `manylinux1_x86_64`, indicates that the resulting wheel should be labeled for 64-bit manylinux1;
this could be changed to create wheels for future manylinux2010 standards.

The docker build will make its own static libraries as part of the build process,
and delete any existing static libraries with `make clean`. The files necessary for a source release
will be left in the appropriate places.

To also produce a source release, run `make sdist` after building the manylinux wheels.
Remember to use the Python virtual environment.

### Releasing to PyPI
The wheels can be uploaded to PyPI (if you're the package maintainer) with

```
(.env) $ twine upload --repository-url https://test.pypi.org/legacy/ wheelhouse/* dist/*
[...]
(.env) $
```

to test on test PyPI, or

```
(.env) $ twine upload wheelhouse/* dist/*
[...]
(.env) $
```

for a release. Remember to build the source distribution after building the wheels.

### Makefile customizations
The Makefiles used to build the static libraries need a few small tweaks to
make sure that all the right flags are given to gcc. The changes are included
in the patch files `softposit_sfpy_build.patch` and `softfloat_sfpy_build.patch`.

The patches can be applied in the standard way. Make sure the submodules are up to date!

```
$ cd SoftPosit
$ git apply ../softposit_sfpy_build.patch
$ cd ../berkeley-softfloat-3
$ git apply ../softfloat_sfpy_build.patch
```
