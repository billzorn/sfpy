all: inplace

NPROCS?=1

INCLUDE_SOURCES = SoftPosit/source/include/softposit.h SoftPosit/source/include/softposit_types.h berkeley-softfloat-3/source/include/softfloat.h berkeley-softfloat-3/source/include/softfloat_types.h
INCLUDES = sfpy/include/softposit.h sfpy/include/softposit_types.h sfpy/include/softfloat.h sfpy/include/softfloat_types.h
LIB_SOURCES = SoftPosit/build/Linux-x86_64-GCC/softposit.a berkeley-softfloat-3/build/Linux-x86_64-GCC/softfloat.a
LIBS = sfpy/lib/softposit.a sfpy/lib/softfloat.a
CYTHONIZED = sfpy/posit.c sfpy/float.c

lib:
	(cd SoftPosit/build/Linux-x86_64-GCC/ && make clean && make pic -j$(NPROCS))
	(cd berkeley-softfloat-3/build/Linux-x86_64-GCC/ && make clean && make -j$(NPROCS))
	mkdir -p sfpy/include sfpy/lib
	cp $(INCLUDE_SOURCES) sfpy/include
	cp $(LIB_SOURCES) sfpy/lib

libclean:
	(cd SoftPosit/build/Linux-x86_64-GCC/ && make clean)
	(cd berkeley-softfloat-3/build/Linux-x86_64-GCC/ && make clean)

cython: $(wildcard sfpy/*.pyx) $(wildcard sfpy/*.pxd)
	cython sfpy/*.pyx

inplace: setup.py $(wildcard sfpy/*.py) $(CYTHONIZED) $(INCLUDES) $(LIBS)
	python setup.py build_ext --inplace

wheel: setup.py $(wildcard sfpy/*.py) $(CYTHONIZED) $(INCLUDES) $(LIBS)
	python setup.py bdist_wheel

sdist: setup.py $(wildcard sfpy/*.py) $(CYTHONIZED) $(INCLUDES) $(LIBS)
	python setup.py sdist

clean:
	rm -f sfpy/*.cpython*.so
	rm -rf sfpy/__pycache__/
	rm -rf sfpy.egg-info/
	rm -rf build/
	rm -rf dist/

distclean:
	rm -f $(CYTHONIZED)
	rm -rf sfpy/include
	rm -rf sfpy/lib

allclean: clean distclean libclean

.PHONY: lib libclean clean distclean allclean
