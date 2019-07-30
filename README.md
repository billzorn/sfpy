# sfpy
softfloat and softposit in Python
  * support for softfloat float16, float32, and float64
  * support for softposit posit8, quire8, posit16, quire16, posit32, and quire32

## Installation

On most linux distros, sfpy should work out of the box:

```
pip install sfpy
```

Binary wheels (compatible with manylinux1) are available for CPython 2.7, 3.5, 3.6, and 3.7.

Under the hood, sfpy uses Cython to create bindings for the softposit and softfloat C libraries.
These building instructions are tested on Ubuntu 18.04 - for other platforms they may need some
adaptation. The cythonized C and compiled static libraries (.a), as well as necessary headers,
are included in the source releases; installing these does not require Cython.

## Demo
```
>>> import sfpy
>>> from sfpy import *
>>> a, b = Float16(1.3), Float16(1.4)
>>> a * b - a / b
Float16(0.89208984375)
>>> sfpy.float.flag_get_inexact()
True
>>> a += b
>>> a
Float16(2.69921875)
>>>
>>> x, y = Posit16(3.0), Posit16(3)
>>> x
Posit16(3.0)
>>> x.bits
22528
>>> y
Posit16(2.9802322387695312e-08)
>>> y.bits
3
>>> x * y
Posit16(8.940696716308594e-08)
>>> acc = Posit16(0)
>>> for i in range(10000):
...   acc = acc.fma(x, y)
... 
>>> acc
Posit16(1.9073486328125e-06)
>>> acc.bits
24
>>> q = Quire16(0)
>>> for i in range(10000):
...   q.iqma(x, y)
... 
>>> q
Quire16(0.00089263916015625)
>>> q.bits
64424509440000
>>> q.to_posit()
Posit16(0.00089263916015625)
>>> q.to_posit().bits
490
```

## Building
See [BUILDING](https://github.com/billzorn/sfpy/blob/master/BUILDING.md).
