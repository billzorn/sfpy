# sfpy
softfloat and softposit in Python
  * support for softposit posit8, quire8, posit16, and quire16
  * no softfloat support yet, still WIP
## Demo
```
>>> from posit import Posit16, Quire16
>>> Posit16(1.3) + Posit16(1.4)
Posit16(2.7001953125)
>>> x = Posit16(7)
>>> x
Posit16(1.7881393432617188e-07)
>>> x += Posit16(9)
>>> x
Posit16(4.76837158203125e-07)
>>> q = Quire16()
>>> q.fdp_add(Posit16(11.0), Posit16(2.0))
>>> q
uA.ui : 29056
Quire16(22.0)
>>> q.p16
uA.ui : 29056
Posit16(22.0)
```
## Building
The cython module can be built in place in the usual way:
`python setup.py build_ext --inplace`
This requires the submodules to be checked out, and the static library `SoftPosit/build/Linux-x86_64-GCC/softposit.a` to be built. Note that in order for cython to be able to build the shared object for the module, the static library must be compiled with -fPIC, which currently requires modifying the appropriate Makefile manually.
