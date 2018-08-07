# sfpy
softfloat and softposit in Python
  * support for softfloat float16, float32, and float64
  * support for softposit posit8, quire8, posit16, and quire16
  
## Demo
```
>>> import sfpy
>>> sfpy.Float32(1.3) + sfpy.Float32(1.4) # <-- construct from doubles
Float32(2.6999998092651367)
>>> sfpy.Float32(3) # <-- construct from raw bits
Float32(4.203895392974451e-45)
>>> sfpy.Float32(3).bits
3
>>> x = sfpy.Float16(0)
>>> x
Float16(0.0)
>>> x += sfpy.Float16(10.0) # <-- in-place operators have better performance
>>> x
Float16(10.0)
>>> sfpy.Posit16(1.3) + sfpy.Posit16(1.4) # <-- posits work the same way as floats
Posit16(2.7001953125)
>>> q = sfpy.Quire16(0) # <-- quire is also supported
>>> q
Quire16(0.0)
>>> q.iqam(sfpy.Posit16(3), sfpy.Posit16(5))
>>> q
Quire16(3.725290298461914e-09)
>>> q.iqam(sfpy.Posit16(3.0), sfpy.Posit16(5.0))
>>> q
Quire16(15.0)
>>> q.bits
1080863910568919232
>>> bin(q.bits)
'0b111100000000000000000000000000000000000000000000000011000000'
```

## Building (on Linux)
The Cython module can be built in place in the usual way:

`python setup.py build_ext --inplace`

This requires the submodules to be checked out, and the static libraries `SoftPosit/build/Linux-x86_64-GCC/softposit.a` and `berkeley-softfloat-3/build/Linux-x86_64-GCC/softfloat.a` to be built. Note that in order for Cython to be able to build the shared objects for the module, the static libraries must be compiled with -fPIC, which currently requires modifying the appropriate Makefiles manually. SoftPosit can be build with -fPIC using its python2 and python3 targets.

The package can also be installed to a local Python distribution with pip, i.e. `pip install .` from the top level of the repository using the appropriate pip. This requires that Cython be installed.
