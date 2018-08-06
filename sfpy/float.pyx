from libc.stdint cimport *
cimport cfloat


# low-level access to rounding modes

ROUND_NEAREST_EVEN = cfloat.softfloat_round_near_even
ROUND_TO_ZERO = cfloat.softfloat_round_minMag
ROUND_DOWN = cfloat.softfloat_round_min
ROUND_UP = cfloat.softfloat_round_max
ROUND_NEAREST_AWAY = cfloat.softfloat_round_near_maxMag

cpdef uint_fast8_t round_get_mode():
    return cfloat.softfloat_roundingMode

cpdef void round_set_mode(uint_fast8_t mode):
    cfloat.softfloat_roundingMode = mode

cpdef bint round_is_nearest_even():
    return cfloat.softfloat_roundingMode == cfloat.softfloat_round_near_even

cpdef void round_set_nearest_even():
    cfloat.softfloat_roundingMode = cfloat.softfloat_round_near_even

cpdef bint round_is_to_zero():
    return cfloat.softfloat_roundingMode == cfloat.softfloat_round_minMag

cpdef void round_set_to_zero():
    cfloat.softfloat_roundingMode = cfloat.softfloat_round_minMag

cpdef bint round_is_down():
    return cfloat.softfloat_roundingMode == cfloat.softfloat_round_min

cpdef void round_set_down():
    cfloat.softfloat_roundingMode = cfloat.softfloat_round_min

cpdef bint round_is_up():
    return cfloat.softfloat_roundingMode == cfloat.softfloat_round_max

cpdef void round_set_up():
    cfloat.softfloat_roundingMode = cfloat.softfloat_round_max

cpdef bint round_is_nearest_away():
    return cfloat.softfloat_roundingMode == cfloat.softfloat_round_near_maxMag

cpdef void round_set_nearest_away():
    cfloat.softfloat_roundingMode = cfloat.softfloat_round_near_maxMag


# low-level access to exception flags

FLAG_INEXACT = cfloat.softfloat_flag_inexact
FLAG_UNDERFLOW = cfloat.softfloat_flag_underflow
FLAG_OVERFLOW = cfloat.softfloat_flag_overflow
FLAG_INFINITE = cfloat.softfloat_flag_infinite
FLAG_INVALID = cfloat.softfloat_flag_invalid

cpdef uint_fast8_t flag_get():
    return cfloat.softfloat_exceptionFlags

cpdef void flag_set(uint_fast8_t flags):
    cfloat.softfloat_exceptionFlags = flags

cpdef void flag_reset():
    cfloat.softfloat_exceptionFlags = 0

cpdef bint flag_get_inexact():
    return (cfloat.softfloat_exceptionFlags & cfloat.softfloat_flag_inexact) != 0

cpdef void flag_raise_inexact():
    cfloat.softfloat_raiseFlags(cfloat.softfloat_flag_inexact)

cpdef void flag_clear_inexact():
    cfloat.softfloat_exceptionFlags &= ~cfloat.softfloat_flag_inexact

cpdef bint flag_get_underflow():
    return (cfloat.softfloat_exceptionFlags & cfloat.softfloat_flag_underflow) != 0

cpdef void flag_raise_underflow():
    cfloat.softfloat_raiseFlags(cfloat.softfloat_flag_underflow)

cpdef void flag_clear_underflow():
    cfloat.softfloat_exceptionFlags &= ~cfloat.softfloat_flag_underflow

cpdef bint flag_get_overflow():
    return (cfloat.softfloat_exceptionFlags & cfloat.softfloat_flag_overflow) != 0

cpdef void flag_raise_overflow():
    cfloat.softfloat_raiseFlags(cfloat.softfloat_flag_overflow)

cpdef void flag_clear_overflow():
    cfloat.softfloat_exceptionFlags &= ~cfloat.softfloat_flag_overflow

cpdef bint flag_get_infinite():
    return (cfloat.softfloat_exceptionFlags & cfloat.softfloat_flag_infinite) != 0

cpdef void flag_raise_infinite():
    cfloat.softfloat_raiseFlags(cfloat.softfloat_flag_infinite)

cpdef void flag_clear_infinite():
    cfloat.softfloat_exceptionFlags &= ~cfloat.softfloat_flag_infinite

cpdef bint flag_get_invalid():
    return (cfloat.softfloat_exceptionFlags & cfloat.softfloat_flag_invalid) != 0

cpdef void flag_raise_invalid():
    cfloat.softfloat_raiseFlags(cfloat.softfloat_flag_invalid)

cpdef void flag_clear_invalid():
    cfloat.softfloat_exceptionFlags &= ~cfloat.softfloat_flag_invalid


cdef class Float16:

    # the wrapped float value
    cdef cfloat.float16_t _c_float

    # factory function constructors that bypass __init__

    @staticmethod
    cdef Float16 from_c_float(cfloat.float16_t f):
        """Factory function to create a Float16 object directly from
        a C float16_t.
        """
        cdef Float16 obj = Float16.__new__(Float16)
        obj._c_float = f
        return obj

    @staticmethod
    def from_bits(uint16_t value):
        """Factory function to create a Float16 object from a bit pattern
        represented as an integer.
        """
        cdef Float16 obj = Float16.__new__(Float16)
        obj._c_float.v = value
        return obj

    @staticmethod
    def from_double(double value):
        """Factory function to create a Float16 object from a double.
        """
        cdef Float16 obj = Float16.__new__(Float16)
        cdef cfloat.ui64_double ud
        cdef cfloat.float64_t d

        ud.d = value
        d.v = ud.u
        obj._c_float = cfloat.f64_to_f16(d)

        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        cdef cfloat.ui64_double ud
        cdef cfloat.float64_t d

        if isinstance(value, int):
            self._c_float.v = value
        else:
            ud.d = float(value)
            d.v = ud.u
            self._c_float = cfloat.f64_to_f16(d)

    def __float__(self):
        cdef cfloat.ui64_double ud
        ud.u = cfloat.f16_to_f64(self._c_float).v
        return ud.d

    def __int__(self):
        cdef cfloat.ui64_double ud
        ud.u = cfloat.f16_to_f64(self._c_float).v
        return int(ud.d)

    def __str__(self):
        cdef cfloat.ui64_double ud
        ud.u = cfloat.f16_to_f64(self._c_float).v
        return repr(ud.d)

    def __repr__(self):
        cdef cfloat.ui64_double ud
        ud.u = cfloat.f16_to_f64(self._c_float).v
        return 'Float16(' + repr(ud.d) + ')'

    cpdef uint16_t get_bits(self):
        return self._c_float.v
    bits = property(get_bits)

    # arithmetic

    cpdef Float16 round_to(self, uint_fast8_t rm, bint exact):
        cdef cfloat.float16_t f = cfloat.f16_roundToInt(self._c_float, rm, exact)
        return Float16.from_c_float(f)

    cpdef Float16 round(self):
        cdef cfloat.float16_t f = cfloat.f16_roundToInt(self._c_float, cfloat.softfloat_roundingMode, True)
        return Float16.from_c_float(f)

    def __round__(self):
        return self.round()

    cpdef Float16 add(self, Float16 other):
        cdef cfloat.float16_t f = cfloat.f16_add(self._c_float, other._c_float)
        return Float16.from_c_float(f)

    def __add__(self, Float16 other):
        return self.add(other)

    cpdef Float16 sub(self, Float16 other):
        cdef cfloat.float16_t f = cfloat.f16_sub(self._c_float, other._c_float)
        return Float16.from_c_float(f)

    def __sub__(self, Float16 other):
        return self.sub(other)

    cpdef Float16 mul(self, Float16 other):
        cdef cfloat.float16_t f = cfloat.f16_mul(self._c_float, other._c_float)
        return Float16.from_c_float(f)

    def __mul__(self, Float16 other):
        return self.mul(other)

    cpdef Float16 fma(self, Float16 a2, Float16 a3):
        cdef cfloat.float16_t f = cfloat.f16_mulAdd(self._c_float, a2._c_float, a3._c_float)
        return Float16.from_c_float(f)

    cpdef Float16 fam(self, Float16 a1, Float16 a2):
        cdef cfloat.float16_t f = cfloat.f16_mulAdd(a1._c_float, a2._c_float, self._c_float)
        return Float16.from_c_float(f)

    cpdef Float16 div(self, Float16 other):
        cdef cfloat.float16_t f = cfloat.f16_div(self._c_float, other._c_float)
        return Float16.from_c_float(f)

    def __truediv__(self, Float16 other):
        return self.div(other)

    cpdef Float16 rem(self, Float16 other):
        cdef cfloat.float16_t f = cfloat.f16_rem(self._c_float, other._c_float)
        return Float16.from_c_float(f)

    cpdef Float16 sqrt(self):
        cdef cfloat.float16_t f = cfloat.f16_sqrt(self._c_float)
        return Float16.from_c_float(f)

    # in-place arithmetic

    cpdef void iround_to(self, uint_fast8_t rm, bint exact):
        self._c_float = cfloat.f16_roundToInt(self._c_float, rm, exact)

    cpdef void iround(self):
        self._c_float = cfloat.f16_roundToInt(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef void iadd(self, Float16 other):
        self._c_float = cfloat.f16_add(self._c_float, other._c_float)

    def __iadd__(self, Float16 other):
        self.iadd(other)
        return self

    cpdef void isub(self, Float16 other):
        self._c_float = cfloat.f16_sub(self._c_float, other._c_float)

    def __isub__(self, Float16 other):
        self.isub(other)
        return self

    cpdef void imul(self, Float16 other):
        self._c_float = cfloat.f16_mul(self._c_float, other._c_float)

    def __imul__(self, Float16 other):
        self.imul(other)
        return self

    cpdef void ifma(self, Float16 a2, Float16 a3):
        self._c_float = cfloat.f16_mulAdd(self._c_float, a2._c_float, a3._c_float)

    cpdef void ifam(self, Float16 a1, Float16 a2):
        self._c_float = cfloat.f16_mulAdd(a1._c_float, a2._c_float, self._c_float)

    cpdef void idiv(self, Float16 other):
        self._c_float = cfloat.f16_div(self._c_float, other._c_float)

    def __itruediv__(self, Float16 other):
        self.idiv(other)
        return self

    cpdef void irem(self, Float16 other):
        self._c_float = cfloat.f16_rem(self._c_float, other._c_float)

    cpdef void isqrt(self):
        self._c_float = cfloat.f16_sqrt(self._c_float)

    # comparison

    cpdef bint eq(self, Float16 other):
        return cfloat.f16_eq(self._c_float, other._c_float)

    cpdef bint le(self, Float16 other):
        return cfloat.f16_le(self._c_float, other._c_float)

    cpdef bint lt(self, Float16 other):
        return cfloat.f16_lt(self._c_float, other._c_float)

    def __lt__(self, Float16 other):
        return self.lt(other)

    def __le__(self, Float16 other):
        return self.le(other)

    def __eq__(self, Float16 other):
        return self.eq(other)

    def __ne__(self, Float16 other):
        return not self.eq(other)

    def __ge__(self, Float16 other):
        return other.le(self)

    def __gt__(self, Float16 other):
        return other.lt(self)

    # conversion to other float types

    cpdef Float32 to_f32(self):
        cdef cfloat.float32_t f = cfloat.f16_to_f32(self._c_float)
        return Float32.from_c_float(f)

    cpdef Float64 to_f64(self):
        cdef cfloat.float64_t f = cfloat.f16_to_f64(self._c_float)
        return Float64.from_c_float(f)


# external, non-method arithmetic

cpdef Float16 f16_round_to(Float16 a1, uint_fast8_t rm, bint exact):
    cdef cfloat.float16_t f = cfloat.f16_roundToInt(a1._c_float, rm, exact)
    return Float16.from_c_float(f)

cpdef Float16 f16_round(Float16 a1):
    cdef cfloat.float16_t f = cfloat.f16_roundToInt(a1._c_float, cfloat.softfloat_roundingMode, True)
    return Float16.from_c_float(f)

cpdef Float16 f16_add(Float16 a1, Float16 a2):
    cdef cfloat.float16_t f = cfloat.f16_add(a1._c_float, a2._c_float)
    return Float16.from_c_float(f)

cpdef Float16 f16_sub(Float16 a1, Float16 a2):
    cdef cfloat.float16_t f = cfloat.f16_sub(a1._c_float, a2._c_float)
    return Float16.from_c_float(f)

cpdef Float16 f16_mul(Float16 a1, Float16 a2):
    cdef cfloat.float16_t f = cfloat.f16_mul(a1._c_float, a2._c_float)
    return Float16.from_c_float(f)

cpdef Float16 f16_fma(Float16 a1, Float16 a2, Float16 a3):
    cdef cfloat.float16_t f = cfloat.f16_mulAdd(a1._c_float, a2._c_float, a3._c_float)
    return Float16.from_c_float(f)

cpdef Float16 f16_fam(Float16 a3, Float16 a1, Float16 a2):
    cdef cfloat.float16_t f = cfloat.f16_mulAdd(a1._c_float, a2._c_float, a3._c_float)
    return Float16.from_c_float(f)

cpdef Float16 f16_div(Float16 a1, Float16 a2):
    cdef cfloat.float16_t f = cfloat.f16_div(a1._c_float, a2._c_float)
    return Float16.from_c_float(f)

cpdef Float16 f16_rem(Float16 a1, Float16 a2):
    cdef cfloat.float16_t f = cfloat.f16_rem(a1._c_float, a2._c_float)
    return Float16.from_c_float(f)

cpdef Float16 f16_sqrt(Float16 a1):
    cdef cfloat.float16_t f = cfloat.f16_sqrt(a1._c_float)
    return Float16.from_c_float(f)

cpdef bint f16_eq(Float16 a1, Float16 a2):
    return cfloat.f16_eq(a1._c_float, a2._c_float)

cpdef bint f16_le(Float16 a1, Float16 a2):
    return cfloat.f16_le(a1._c_float, a2._c_float)

cpdef bint f16_lt(Float16 a1, Float16 a2):
    return cfloat.f16_lt(a1._c_float, a2._c_float)

cpdef Float32 f16_to_f32(Float16 a1):
    cdef cfloat.float32_t f = cfloat.f16_to_f32(a1._c_float)
    return Float32.from_c_float(f)

cpdef Float64 f16_to_f64(Float16 a1):
    cdef cfloat.float64_t f = cfloat.f16_to_f64(a1._c_float)
    return Float64.from_c_float(f)


cdef class Float32:

    # the wrapped float value
    cdef cfloat.float32_t _c_float

    # factory function constructors that bypass __init__

    @staticmethod
    cdef Float32 from_c_float(cfloat.float32_t f):
        """Factory function to create a Float32 object directly from
        a C float32_t.
        """
        cdef Float32 obj = Float32.__new__(Float32)
        obj._c_float = f
        return obj

    @staticmethod
    def from_bits(uint32_t value):
        """Factory function to create a Float32 object from a bit pattern
        represented as an integer.
        """
        cdef Float32 obj = Float32.__new__(Float32)
        obj._c_float.v = value
        return obj

    @staticmethod
    def from_double(double value):
        """Factory function to create a Float32 object from a double.
        """
        cdef Float32 obj = Float32.__new__(Float32)
        cdef cfloat.ui64_double ud
        cdef cfloat.float64_t d

        ud.d = value
        d.v = ud.u
        obj._c_float = cfloat.f64_to_f32(d)

        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        cdef cfloat.ui64_double ud
        cdef cfloat.float64_t d

        if isinstance(value, int):
            self._c_float.v = value
        else:
            ud.d = float(value)
            d.v = ud.u
            self._c_float = cfloat.f64_to_f32(d)

    def __float__(self):
        cdef cfloat.ui64_double ud
        ud.u = cfloat.f32_to_f64(self._c_float).v
        return ud.d

    def __int__(self):
        cdef cfloat.ui64_double ud
        ud.u = cfloat.f32_to_f64(self._c_float).v
        return int(ud.d)

    def __str__(self):
        cdef cfloat.ui64_double ud
        ud.u = cfloat.f32_to_f64(self._c_float).v
        return repr(ud.d)

    def __repr__(self):
        cdef cfloat.ui64_double ud
        ud.u = cfloat.f32_to_f64(self._c_float).v
        return 'Float32(' + repr(ud.d) + ')'

    cpdef uint32_t get_bits(self):
        return self._c_float.v
    bits = property(get_bits)

    # arithmetic

    cpdef Float32 round_to(self, uint_fast8_t rm, bint exact):
        cdef cfloat.float32_t f = cfloat.f32_roundToInt(self._c_float, rm, exact)
        return Float32.from_c_float(f)

    cpdef Float32 round(self):
        cdef cfloat.float32_t f = cfloat.f32_roundToInt(self._c_float, cfloat.softfloat_roundingMode, True)
        return Float32.from_c_float(f)

    def __round__(self):
        return self.round()

    cpdef Float32 add(self, Float32 other):
        cdef cfloat.float32_t f = cfloat.f32_add(self._c_float, other._c_float)
        return Float32.from_c_float(f)

    def __add__(self, Float32 other):
        return self.add(other)

    cpdef Float32 sub(self, Float32 other):
        cdef cfloat.float32_t f = cfloat.f32_sub(self._c_float, other._c_float)
        return Float32.from_c_float(f)

    def __sub__(self, Float32 other):
        return self.sub(other)

    cpdef Float32 mul(self, Float32 other):
        cdef cfloat.float32_t f = cfloat.f32_mul(self._c_float, other._c_float)
        return Float32.from_c_float(f)

    def __mul__(self, Float32 other):
        return self.mul(other)

    cpdef Float32 fma(self, Float32 a2, Float32 a3):
        cdef cfloat.float32_t f = cfloat.f32_mulAdd(self._c_float, a2._c_float, a3._c_float)
        return Float32.from_c_float(f)

    cpdef Float32 fam(self, Float32 a1, Float32 a2):
        cdef cfloat.float32_t f = cfloat.f32_mulAdd(a1._c_float, a2._c_float, self._c_float)
        return Float32.from_c_float(f)

    cpdef Float32 div(self, Float32 other):
        cdef cfloat.float32_t f = cfloat.f32_div(self._c_float, other._c_float)
        return Float32.from_c_float(f)

    def __truediv__(self, Float32 other):
        return self.div(other)

    cpdef Float32 rem(self, Float32 other):
        cdef cfloat.float32_t f = cfloat.f32_rem(self._c_float, other._c_float)
        return Float32.from_c_float(f)

    cpdef Float32 sqrt(self):
        cdef cfloat.float32_t f = cfloat.f32_sqrt(self._c_float)
        return Float32.from_c_float(f)

    # in-place arithmetic

    cpdef void iround_to(self, uint_fast8_t rm, bint exact):
        self._c_float = cfloat.f32_roundToInt(self._c_float, rm, exact)

    cpdef void iround(self):
        self._c_float = cfloat.f32_roundToInt(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef void iadd(self, Float32 other):
        self._c_float = cfloat.f32_add(self._c_float, other._c_float)

    def __iadd__(self, Float32 other):
        self.iadd(other)
        return self

    cpdef void isub(self, Float32 other):
        self._c_float = cfloat.f32_sub(self._c_float, other._c_float)

    def __isub__(self, Float32 other):
        self.isub(other)
        return self

    cpdef void imul(self, Float32 other):
        self._c_float = cfloat.f32_mul(self._c_float, other._c_float)

    def __imul__(self, Float32 other):
        self.imul(other)
        return self

    cpdef void ifma(self, Float32 a2, Float32 a3):
        self._c_float = cfloat.f32_mulAdd(self._c_float, a2._c_float, a3._c_float)

    cpdef void ifam(self, Float32 a1, Float32 a2):
        self._c_float = cfloat.f32_mulAdd(a1._c_float, a2._c_float, self._c_float)

    cpdef void idiv(self, Float32 other):
        self._c_float = cfloat.f32_div(self._c_float, other._c_float)

    def __itruediv__(self, Float32 other):
        self.idiv(other)
        return self

    cpdef void irem(self, Float32 other):
        self._c_float = cfloat.f32_rem(self._c_float, other._c_float)

    cpdef void isqrt(self):
        self._c_float = cfloat.f32_sqrt(self._c_float)

    # comparison

    cpdef bint eq(self, Float32 other):
        return cfloat.f32_eq(self._c_float, other._c_float)

    cpdef bint le(self, Float32 other):
        return cfloat.f32_le(self._c_float, other._c_float)

    cpdef bint lt(self, Float32 other):
        return cfloat.f32_lt(self._c_float, other._c_float)

    def __lt__(self, Float32 other):
        return self.lt(other)

    def __le__(self, Float32 other):
        return self.le(other)

    def __eq__(self, Float32 other):
        return self.eq(other)

    def __ne__(self, Float32 other):
        return not self.eq(other)

    def __ge__(self, Float32 other):
        return other.le(self)

    def __gt__(self, Float32 other):
        return other.lt(self)

    # conversion to other float types

    cpdef Float16 to_f16(self):
        cdef cfloat.float16_t f = cfloat.f32_to_f16(self._c_float)
        return Float16.from_c_float(f)

    cpdef Float64 to_f64(self):
        cdef cfloat.float64_t f = cfloat.f32_to_f64(self._c_float)
        return Float64.from_c_float(f)


# external, non-method arithmetic

cpdef Float32 f32_round_to(Float32 a1, uint_fast8_t rm, bint exact):
    cdef cfloat.float32_t f = cfloat.f32_roundToInt(a1._c_float, rm, exact)
    return Float32.from_c_float(f)

cpdef Float32 f32_round(Float32 a1):
    cdef cfloat.float32_t f = cfloat.f32_roundToInt(a1._c_float, cfloat.softfloat_roundingMode, True)
    return Float32.from_c_float(f)

cpdef Float32 f32_add(Float32 a1, Float32 a2):
    cdef cfloat.float32_t f = cfloat.f32_add(a1._c_float, a2._c_float)
    return Float32.from_c_float(f)

cpdef Float32 f32_sub(Float32 a1, Float32 a2):
    cdef cfloat.float32_t f = cfloat.f32_sub(a1._c_float, a2._c_float)
    return Float32.from_c_float(f)

cpdef Float32 f32_mul(Float32 a1, Float32 a2):
    cdef cfloat.float32_t f = cfloat.f32_mul(a1._c_float, a2._c_float)
    return Float32.from_c_float(f)

cpdef Float32 f32_fma(Float32 a1, Float32 a2, Float32 a3):
    cdef cfloat.float32_t f = cfloat.f32_mulAdd(a1._c_float, a2._c_float, a3._c_float)
    return Float32.from_c_float(f)

cpdef Float32 f32_fam(Float32 a3, Float32 a1, Float32 a2):
    cdef cfloat.float32_t f = cfloat.f32_mulAdd(a1._c_float, a2._c_float, a3._c_float)
    return Float32.from_c_float(f)

cpdef Float32 f32_div(Float32 a1, Float32 a2):
    cdef cfloat.float32_t f = cfloat.f32_div(a1._c_float, a2._c_float)
    return Float32.from_c_float(f)

cpdef Float32 f32_rem(Float32 a1, Float32 a2):
    cdef cfloat.float32_t f = cfloat.f32_rem(a1._c_float, a2._c_float)
    return Float32.from_c_float(f)

cpdef Float32 f32_sqrt(Float32 a1):
    cdef cfloat.float32_t f = cfloat.f32_sqrt(a1._c_float)
    return Float32.from_c_float(f)

cpdef bint f32_eq(Float32 a1, Float32 a2):
    return cfloat.f32_eq(a1._c_float, a2._c_float)

cpdef bint f32_le(Float32 a1, Float32 a2):
    return cfloat.f32_le(a1._c_float, a2._c_float)

cpdef bint f32_lt(Float32 a1, Float32 a2):
    return cfloat.f32_lt(a1._c_float, a2._c_float)

cpdef Float16 f32_to_f16(Float32 a1):
    cdef cfloat.float16_t f = cfloat.f32_to_f16(a1._c_float)
    return Float16.from_c_float(f)

cpdef Float64 f32_to_f64(Float32 a1):
    cdef cfloat.float64_t f = cfloat.f32_to_f64(a1._c_float)
    return Float64.from_c_float(f)


cdef class Float64:

    # the wrapped float value
    cdef cfloat.float64_t _c_float

    # factory function constructors that bypass __init__

    @staticmethod
    cdef Float64 from_c_float(cfloat.float64_t f):
        """Factory function to create a Float64 object directly from
        a C float64_t.
        """
        cdef Float64 obj = Float64.__new__(Float64)
        obj._c_float = f
        return obj

    @staticmethod
    def from_bits(uint64_t value):
        """Factory function to create a Float64 object from a bit pattern
        represented as an integer.
        """
        cdef Float64 obj = Float64.__new__(Float64)
        obj._c_float.v = value
        return obj

    @staticmethod
    def from_double(double value):
        """Factory function to create a Float64 object from a double.
        """
        cdef Float64 obj = Float64.__new__(Float64)
        cdef cfloat.ui64_double ud
        cdef cfloat.float64_t d

        ud.d = value
        obj._c_float.v = ud.u

        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        cdef cfloat.ui64_double ud
        cdef cfloat.float64_t d

        if isinstance(value, int):
            self._c_float.v = value
        else:
            ud.d = float(value)
            self._c_float.v = ud.u

    def __float__(self):
        cdef cfloat.ui64_double ud
        ud.u = self._c_float.v
        return ud.d

    def __int__(self):
        cdef cfloat.ui64_double ud
        ud.u = self._c_float.v
        return int(ud.d)

    def __str__(self):
        cdef cfloat.ui64_double ud
        ud.u = self._c_float.v
        return repr(ud.d)

    def __repr__(self):
        cdef cfloat.ui64_double ud
        ud.u = self._c_float.v
        return 'Float64(' + repr(ud.d) + ')'

    cpdef uint64_t get_bits(self):
        return self._c_float.v
    bits = property(get_bits)

    # arithmetic

    cpdef Float64 round_to(self, uint_fast8_t rm, bint exact):
        cdef cfloat.float64_t f = cfloat.f64_roundToInt(self._c_float, rm, exact)
        return Float64.from_c_float(f)

    cpdef Float64 round(self):
        cdef cfloat.float64_t f = cfloat.f64_roundToInt(self._c_float, cfloat.softfloat_roundingMode, True)
        return Float64.from_c_float(f)

    def __round__(self):
        return self.round()

    cpdef Float64 add(self, Float64 other):
        cdef cfloat.float64_t f = cfloat.f64_add(self._c_float, other._c_float)
        return Float64.from_c_float(f)

    def __add__(self, Float64 other):
        return self.add(other)

    cpdef Float64 sub(self, Float64 other):
        cdef cfloat.float64_t f = cfloat.f64_sub(self._c_float, other._c_float)
        return Float64.from_c_float(f)

    def __sub__(self, Float64 other):
        return self.sub(other)

    cpdef Float64 mul(self, Float64 other):
        cdef cfloat.float64_t f = cfloat.f64_mul(self._c_float, other._c_float)
        return Float64.from_c_float(f)

    def __mul__(self, Float64 other):
        return self.mul(other)

    cpdef Float64 fma(self, Float64 a2, Float64 a3):
        cdef cfloat.float64_t f = cfloat.f64_mulAdd(self._c_float, a2._c_float, a3._c_float)
        return Float64.from_c_float(f)

    cpdef Float64 fam(self, Float64 a1, Float64 a2):
        cdef cfloat.float64_t f = cfloat.f64_mulAdd(a1._c_float, a2._c_float, self._c_float)
        return Float64.from_c_float(f)

    cpdef Float64 div(self, Float64 other):
        cdef cfloat.float64_t f = cfloat.f64_div(self._c_float, other._c_float)
        return Float64.from_c_float(f)

    def __truediv__(self, Float64 other):
        return self.div(other)

    cpdef Float64 rem(self, Float64 other):
        cdef cfloat.float64_t f = cfloat.f64_rem(self._c_float, other._c_float)
        return Float64.from_c_float(f)

    cpdef Float64 sqrt(self):
        cdef cfloat.float64_t f = cfloat.f64_sqrt(self._c_float)
        return Float64.from_c_float(f)

    # in-place arithmetic

    cpdef void iround_to(self, uint_fast8_t rm, bint exact):
        self._c_float = cfloat.f64_roundToInt(self._c_float, rm, exact)

    cpdef void iround(self):
        self._c_float = cfloat.f64_roundToInt(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef void iadd(self, Float64 other):
        self._c_float = cfloat.f64_add(self._c_float, other._c_float)

    def __iadd__(self, Float64 other):
        self.iadd(other)
        return self

    cpdef void isub(self, Float64 other):
        self._c_float = cfloat.f64_sub(self._c_float, other._c_float)

    def __isub__(self, Float64 other):
        self.isub(other)
        return self

    cpdef void imul(self, Float64 other):
        self._c_float = cfloat.f64_mul(self._c_float, other._c_float)

    def __imul__(self, Float64 other):
        self.imul(other)
        return self

    cpdef void ifma(self, Float64 a2, Float64 a3):
        self._c_float = cfloat.f64_mulAdd(self._c_float, a2._c_float, a3._c_float)

    cpdef void ifam(self, Float64 a1, Float64 a2):
        self._c_float = cfloat.f64_mulAdd(a1._c_float, a2._c_float, self._c_float)

    cpdef void idiv(self, Float64 other):
        self._c_float = cfloat.f64_div(self._c_float, other._c_float)

    def __itruediv__(self, Float64 other):
        self.idiv(other)
        return self

    cpdef void irem(self, Float64 other):
        self._c_float = cfloat.f64_rem(self._c_float, other._c_float)

    cpdef void isqrt(self):
        self._c_float = cfloat.f64_sqrt(self._c_float)

    # comparison

    cpdef bint eq(self, Float64 other):
        return cfloat.f64_eq(self._c_float, other._c_float)

    cpdef bint le(self, Float64 other):
        return cfloat.f64_le(self._c_float, other._c_float)

    cpdef bint lt(self, Float64 other):
        return cfloat.f64_lt(self._c_float, other._c_float)

    def __lt__(self, Float64 other):
        return self.lt(other)

    def __le__(self, Float64 other):
        return self.le(other)

    def __eq__(self, Float64 other):
        return self.eq(other)

    def __ne__(self, Float64 other):
        return not self.eq(other)

    def __ge__(self, Float64 other):
        return other.le(self)

    def __gt__(self, Float64 other):
        return other.lt(self)

    # conversion to other float types

    cpdef Float16 to_f16(self):
        cdef cfloat.float16_t f = cfloat.f64_to_f16(self._c_float)
        return Float16.from_c_float(f)

    cpdef Float32 to_f32(self):
        cdef cfloat.float32_t f = cfloat.f64_to_f32(self._c_float)
        return Float32.from_c_float(f)


# external, non-method arithmetic

cpdef Float64 f64_round_to(Float64 a1, uint_fast8_t rm, bint exact):
    cdef cfloat.float64_t f = cfloat.f64_roundToInt(a1._c_float, rm, exact)
    return Float64.from_c_float(f)

cpdef Float64 f64_round(Float64 a1):
    cdef cfloat.float64_t f = cfloat.f64_roundToInt(a1._c_float, cfloat.softfloat_roundingMode, True)
    return Float64.from_c_float(f)

cpdef Float64 f64_add(Float64 a1, Float64 a2):
    cdef cfloat.float64_t f = cfloat.f64_add(a1._c_float, a2._c_float)
    return Float64.from_c_float(f)

cpdef Float64 f64_sub(Float64 a1, Float64 a2):
    cdef cfloat.float64_t f = cfloat.f64_sub(a1._c_float, a2._c_float)
    return Float64.from_c_float(f)

cpdef Float64 f64_mul(Float64 a1, Float64 a2):
    cdef cfloat.float64_t f = cfloat.f64_mul(a1._c_float, a2._c_float)
    return Float64.from_c_float(f)

cpdef Float64 f64_fma(Float64 a1, Float64 a2, Float64 a3):
    cdef cfloat.float64_t f = cfloat.f64_mulAdd(a1._c_float, a2._c_float, a3._c_float)
    return Float64.from_c_float(f)

cpdef Float64 f64_fam(Float64 a3, Float64 a1, Float64 a2):
    cdef cfloat.float64_t f = cfloat.f64_mulAdd(a1._c_float, a2._c_float, a3._c_float)
    return Float64.from_c_float(f)

cpdef Float64 f64_div(Float64 a1, Float64 a2):
    cdef cfloat.float64_t f = cfloat.f64_div(a1._c_float, a2._c_float)
    return Float64.from_c_float(f)

cpdef Float64 f64_rem(Float64 a1, Float64 a2):
    cdef cfloat.float64_t f = cfloat.f64_rem(a1._c_float, a2._c_float)
    return Float64.from_c_float(f)

cpdef Float64 f64_sqrt(Float64 a1):
    cdef cfloat.float64_t f = cfloat.f64_sqrt(a1._c_float)
    return Float64.from_c_float(f)

cpdef bint f64_eq(Float64 a1, Float64 a2):
    return cfloat.f64_eq(a1._c_float, a2._c_float)

cpdef bint f64_le(Float64 a1, Float64 a2):
    return cfloat.f64_le(a1._c_float, a2._c_float)

cpdef bint f64_lt(Float64 a1, Float64 a2):
    return cfloat.f64_lt(a1._c_float, a2._c_float)

cpdef Float16 f64_to_f16(Float64 a1):
    cdef cfloat.float16_t f = cfloat.f64_to_f16(a1._c_float)
    return Float16.from_c_float(f)

cpdef Float32 f64_to_f32(Float64 a1):
    cdef cfloat.float32_t f = cfloat.f64_to_f32(a1._c_float)
    return Float32.from_c_float(f)
