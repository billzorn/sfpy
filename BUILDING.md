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

### Cython extensions
Compile the Cython extensions to C:

```
(.env) $ cython sfpy/*.pyx
(.env) $
```

### Static libraries
The extension module depends on the softposit and softfloat static libraries.
They can be built with the following:

```
(.env) $ (cd SoftPosit/build/Linux-x86_64-GCC/; make clean; make)
[...]
(.env) $ (cd berkeley-softfloat-3/build/Linux-x86_64-GCC/; make clean; make)
[...]
(.env) $
```

Note that some changes are needed to the Makefiles so that the libraries are
compiled with the correct options. Both libraries need to use -fPIC, and
SoftPosit may need -std=c99 to work on older versions of GCC. See the
diff below.

### Building locally
The extension modules can be built in place in the usual way:

```
(.env) $ python setup.py build_ext --inplace
[...]
(.env) $
```

A local wheel (compatible with the python version installed in the virtual
environment) can be built with the following:

```
(.env) $ python setup.py bdist_wheel
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

### Building manylinux1 wheels for distribution
Widely compatible linux wheels can be built with the help of PyPA's manylinux
docker image. This requires that Docker is installed, and that the host can pull
the proper docker image.

To build the manylinux wheels, run:

```
$ sudo docker run -u $(id -u) --rm -v `pwd`:/io quay.io/pypa/manylinux1_x86_64 /io/docker-build-wheels.sh
[...]
$
```

This will create a set of manylinux1 wheel files in the `wheelhouse/` directory.

The docker build will make its own static libraries as part of the build process,
and delete any existing static libraries with `make clean`.

The wheels can be uploaded to PyPI (if you're the package maintainer) with

```
(.env) $ twine upload --repository-url https://test.pypi.org/legacy/ wheelhouse/*
[...]
(.env) $
```

to test on test PyPI, or

```
(.env) $ twine upload wheelhouse/*
[...]
(.env) $
```

for a release.

### Makefile customizations
The Makefiles used to build the static libraries need a few small tweaks to
make sure that all the right flags are given to gcc. The changes are shown
in the following diffs.

`SoftPosit/build/Linux-x86_64/Makefile`

```diff
diff --git a/build/Linux-x86_64-GCC/Makefile b/build/Linux-x86_64-GCC/Makefile
index 4409e43..46bb877 100644
--- a/build/Linux-x86_64-GCC/Makefile
+++ b/build/Linux-x86_64-GCC/Makefile
@@ -60,9 +60,9 @@ LINK_PYTHON = \

 DELETE = rm -f
 C_INCLUDES = -I. -I$(SOURCE_DIR)/$(SPECIALIZE_TYPE) -I$(SOURCE_DIR)/include
-OPTIMISATION  = -march=core-avx2 -O2
+OPTIMISATION  = -fPIC -O2 ^M
 COMPILE_C = \
-  gcc -c -Werror-implicit-function-declaration -DSOFTPOSIT_FAST_INT64 \
+  gcc -std=c99 -c -Werror-implicit-function-declaration -DSOFTPOSIT_FAST_INT64 \^M
     $(SOFTPOSIT_OPTS) $(C_INCLUDES) $(OPTIMISATION) \
     -o $@
 MAKELIB = ar crs $@
```

`berkeley-softfloat-3/build/Linux-x86_64/Makefile`

```diff
diff --git a/build/Linux-x86_64-GCC/Makefile b/build/Linux-x86_64-GCC/Makefile
index 2ee5dad..b175964 100644
--- a/build/Linux-x86_64-GCC/Makefile
+++ b/build/Linux-x86_64-GCC/Makefile
@@ -45,7 +45,7 @@ DELETE = rm -f
 C_INCLUDES = -I. -I$(SOURCE_DIR)/$(SPECIALIZE_TYPE) -I$(SOURCE_DIR)/include
 COMPILE_C = \
   gcc -c -Werror-implicit-function-declaration -DSOFTFLOAT_FAST_INT64 \
-    $(SOFTFLOAT_OPTS) $(C_INCLUDES) -O2 -o $@
+    $(SOFTFLOAT_OPTS) $(C_INCLUDES) -O2 -fPIC -o $@
 MAKELIB = ar crs $@

 OBJ = .o
```
