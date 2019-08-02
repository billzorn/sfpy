# cython: language_level=3

from libc.stdint cimport *
from . cimport cfloat


# low-level access to tininess detection

TININESS_BEFORE_ROUNDING = cfloat.softfloat_tininess_beforeRounding
TININESS_AFTER_ROUNDING = cfloat.softfloat_tininess_afterRounding

cpdef uint_fast8_t tininess_get():
    return cfloat.softfloat_detectTininess

cpdef void tininess_set(uint_fast8_t tininess):
    cfloat.softfloat_detectTininess = tininess

cpdef bint tininess_is_before_rounding():
    return cfloat.softfloat_detectTininess == cfloat.softfloat_tininess_beforeRounding

cpdef void tininess_set_before_rounding():
    cfloat.softfloat_detectTininess = cfloat.softfloat_tininess_beforeRounding

cpdef bint tininess_is_after_rounding():
    return cfloat.softfloat_detectTininess == cfloat.softfloat_tininess_afterRounding

cpdef void tininess_set_after_rounding():
    cfloat.softfloat_detectTininess = cfloat.softfloat_tininess_afterRounding


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


# C helpers

cdef inline cfloat.float16_t _f16_neg(cfloat.float16_t f):
    f.v ^= 0x8000
    return f

cdef inline cfloat.float32_t _f32_neg(cfloat.float32_t f):
    f.v ^= 0x80000000
    return f

cdef inline cfloat.float64_t _f64_neg(cfloat.float64_t f):
    f.v ^= 0x8000000000000000
    return f

cdef inline cfloat.float16_t _f16_abs(cfloat.float16_t f):
    f.v &= 0x7fff
    return f

cdef inline cfloat.float32_t _f32_abs(cfloat.float32_t f):
    f.v &= 0x7fffffff
    return f

cdef inline cfloat.float64_t _f64_abs(cfloat.float64_t f):
    f.v &= 0x7fffffffffffffff
    return f


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

    @staticmethod
    def from_i32(int32_t value):
        """Factory function to create a Float16 object from a signed int32.
        """
        cdef Float16 obj = Float16.__new__(Float16)
        obj._c_float = cfloat.i32_to_f16(value)
        return obj

    @staticmethod
    def from_ui32(uint32_t value):
        """Factory function to create a Float16 object from an unsigned uint32.
        """
        cdef Float16 obj = Float16.__new__(Float16)
        obj._c_float = cfloat.ui32_to_f16(value)
        return obj

    @staticmethod
    def from_i64(int64_t value):
        """Factory function to create a Float16 object from a signed int64.
        """
        cdef Float16 obj = Float16.__new__(Float16)
        obj._c_float = cfloat.i64_to_f16(value)
        return obj

    @staticmethod
    def from_ui64(uint64_t value):
        """Factory function to create a Float16 object from an unsigned uint64.
        """
        cdef Float16 obj = Float16.__new__(Float16)
        obj._c_float = cfloat.ui64_to_f16(value)
        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        """Given an int, create a Float16 from the bitpattern represented by
        that int. Otherwise, given some value, create a Float16 by rounding
        float(value).
        """
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

    cpdef Float16 neg(self):
        cdef cfloat.float16_t f = _f16_neg(self._c_float)
        return Float16.from_c_float(f)

    def __neg__(self):
        return self.neg()

    cpdef Float16 abs(self):
        cdef cfloat.float16_t f = _f16_abs(self._c_float)
        return Float16.from_c_float(f)

    def __abs__(self):
        return self.abs()

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

    cpdef Float16 fma(self, Float16 a1, Float16 a2):
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

    cpdef void ineg(self):
        self._c_float = _f16_neg(self._c_float)

    cpdef void iabs(self):
        self._c_float = _f16_abs(self._c_float)

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

    cpdef void ifma(self, Float16 a1, Float16 a2):
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

    # conversion to integer types

    cpdef int32_t to_i32(self):
        return cfloat.f16_to_i32(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef uint32_t to_ui32(self):
        return cfloat.f16_to_ui32(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef int64_t to_i64(self):
        return cfloat.f16_to_i64(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef uint64_t to_ui64(self):
        return cfloat.f16_to_ui64(self._c_float, cfloat.softfloat_roundingMode, True)

# external, non-method arithmetic

cpdef Float16 f16_neg(Float16 a1):
    cdef cfloat.float16_t f = _f16_neg(a1._c_float)
    return Float16.from_c_float(f)

cpdef Float16 f16_abs(Float16 a1):
    cdef cfloat.float16_t f = _f16_abs(a1._c_float)
    return Float16.from_c_float(f)

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

cpdef Float16 f16_fma(Float16 acc, Float16 a1, Float16 a2):
    cdef cfloat.float16_t f = cfloat.f16_mulAdd(a1._c_float, a2._c_float, acc._c_float)
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

# u/i32 <-> f16

cpdef Float16 i32_to_f16(int32_t value):
    cdef cfloat.float16_t f = cfloat.i32_to_f16(value)
    return Float16.from_c_float(f)

cpdef Float16 ui32_to_f16(uint32_t value):
    cdef cfloat.float16_t f = cfloat.ui32_to_f16(value)
    return Float16.from_c_float(f)

cpdef int32_t f16_to_i32(Float16 a1):
    return cfloat.f16_to_i32(a1._c_float, cfloat.softfloat_roundingMode, True)

cpdef uint32_t f16_to_ui32(Float16 a1):
    return cfloat.f16_to_ui32(a1._c_float, cfloat.softfloat_roundingMode, True)

# u/i64 <-> f16

cpdef Float16 i64_to_f16(int64_t value):
    cdef cfloat.float16_t f = cfloat.i64_to_f16(value)
    return Float16.from_c_float(f)

cpdef Float16 ui64_to_f16(uint64_t value):
    cdef cfloat.float16_t f = cfloat.ui64_to_f16(value)
    return Float16.from_c_float(f)

cpdef int64_t f16_to_i64(Float16 a1):
    return cfloat.f16_to_i64(a1._c_float, cfloat.softfloat_roundingMode, True)

cpdef uint64_t f16_to_ui64(Float16 a1):
    return cfloat.f16_to_ui64(a1._c_float, cfloat.softfloat_roundingMode, True)


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

    @staticmethod
    def from_i32(int32_t value):
        """Factory function to create a Float32 object from a signed int32.
        """
        cdef Float32 obj = Float32.__new__(Float32)
        obj._c_float = cfloat.i32_to_f32(value)
        return obj

    @staticmethod
    def from_ui32(uint32_t value):
        """Factory function to create a Float32 object from an unsigned uint32.
        """
        cdef Float32 obj = Float32.__new__(Float32)
        obj._c_float = cfloat.ui32_to_f32(value)
        return obj

    @staticmethod
    def from_i64(int64_t value):
        """Factory function to create a Float32 object from a signed int64.
        """
        cdef Float32 obj = Float32.__new__(Float32)
        obj._c_float = cfloat.i64_to_f32(value)
        return obj

    @staticmethod
    def from_ui64(uint64_t value):
        """Factory function to create a Float32 object from an unsigned uint64.
        """
        cdef Float32 obj = Float32.__new__(Float32)
        obj._c_float = cfloat.ui64_to_f32(value)
        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        """Given an int, create a Float32 from the bitpattern represented by
        that int. Otherwise, given some value, create a Float32 by rounding
        float(value).
        """
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

    cpdef Float32 neg(self):
        cdef cfloat.float32_t f = _f32_neg(self._c_float)
        return Float32.from_c_float(f)

    def __neg__(self):
        return self.neg()

    cpdef Float32 abs(self):
        cdef cfloat.float32_t f = _f32_abs(self._c_float)
        return Float32.from_c_float(f)

    def __abs__(self):
        return self.abs()

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

    cpdef Float32 fma(self, Float32 a1, Float32 a2):
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

    cpdef void ineg(self):
        self._c_float = _f32_neg(self._c_float)

    cpdef void iabs(self):
        self._c_float = _f32_abs(self._c_float)

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

    cpdef void ifma(self, Float32 a1, Float32 a2):
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

    # conversion to integer types

    cpdef int32_t to_i32(self):
        return cfloat.f32_to_i32(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef uint32_t to_ui32(self):
        return cfloat.f32_to_ui32(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef int64_t to_i64(self):
        return cfloat.f32_to_i64(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef uint64_t to_ui64(self):
        return cfloat.f32_to_ui64(self._c_float, cfloat.softfloat_roundingMode, True)

# external, non-method arithmetic

cpdef Float32 f32_neg(Float32 a1):
    cdef cfloat.float32_t f = _f32_neg(a1._c_float)
    return Float32.from_c_float(f)

cpdef Float32 f32_abs(Float32 a1):
    cdef cfloat.float32_t f = _f32_abs(a1._c_float)
    return Float32.from_c_float(f)

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

cpdef Float32 f32_fma(Float32 acc, Float32 a1, Float32 a2):
    cdef cfloat.float32_t f = cfloat.f32_mulAdd(a1._c_float, a2._c_float, acc._c_float)
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

# u/i32 <-> f32

cpdef Float32 i32_to_f32(int32_t value):
    cdef cfloat.float32_t f = cfloat.i32_to_f32(value)
    return Float32.from_c_float(f)

cpdef Float32 ui32_to_f32(uint32_t value):
    cdef cfloat.float32_t f = cfloat.ui32_to_f32(value)
    return Float32.from_c_float(f)

cpdef int32_t f32_to_i32(Float32 a1):
    return cfloat.f32_to_i32(a1._c_float, cfloat.softfloat_roundingMode, True)

cpdef uint32_t f32_to_ui32(Float32 a1):
    return cfloat.f32_to_ui32(a1._c_float, cfloat.softfloat_roundingMode, True)

# u/i64 <-> f32

cpdef Float32 i64_to_f32(int64_t value):
    cdef cfloat.float32_t f = cfloat.i64_to_f32(value)
    return Float32.from_c_float(f)

cpdef Float32 ui64_to_f32(uint64_t value):
    cdef cfloat.float32_t f = cfloat.ui64_to_f32(value)
    return Float32.from_c_float(f)

cpdef int64_t f32_to_i64(Float32 a1):
    return cfloat.f32_to_i64(a1._c_float, cfloat.softfloat_roundingMode, True)

cpdef uint64_t f32_to_ui64(Float32 a1):
    return cfloat.f32_to_ui64(a1._c_float, cfloat.softfloat_roundingMode, True)


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

    @staticmethod
    def from_i32(int32_t value):
        """Factory function to create a Float64 object from a signed int32.
        """
        cdef Float64 obj = Float64.__new__(Float64)
        obj._c_float = cfloat.i32_to_f64(value)
        return obj

    @staticmethod
    def from_ui32(uint32_t value):
        """Factory function to create a Float64 object from an unsigned uint32.
        """
        cdef Float64 obj = Float64.__new__(Float64)
        obj._c_float = cfloat.ui32_to_f64(value)
        return obj

    @staticmethod
    def from_i64(int64_t value):
        """Factory function to create a Float64 object from a signed int64.
        """
        cdef Float64 obj = Float64.__new__(Float64)
        obj._c_float = cfloat.i64_to_f64(value)
        return obj

    @staticmethod
    def from_ui64(uint64_t value):
        """Factory function to create a Float64 object from an unsigned uint64.
        """
        cdef Float64 obj = Float64.__new__(Float64)
        obj._c_float = cfloat.ui64_to_f64(value)
        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        """Given an int, create a Float64 from the bitpattern represented by
        that int. Otherwise, given some value, create a Float64 from
        float(value).
        """
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

    cpdef Float64 neg(self):
        cdef cfloat.float64_t f = _f64_neg(self._c_float)
        return Float64.from_c_float(f)

    def __neg__(self):
        return self.neg()

    cpdef Float64 abs(self):
        cdef cfloat.float64_t f = _f64_abs(self._c_float)
        return Float64.from_c_float(f)

    def __abs__(self):
        return self.abs()

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

    cpdef Float64 fma(self, Float64 a1, Float64 a2):
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

    cpdef void ineg(self):
        self._c_float = _f64_neg(self._c_float)

    cpdef void iabs(self):
        self._c_float = _f64_abs(self._c_float)

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

    cpdef void ifma(self, Float64 a1, Float64 a2):
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

    # conversion to integer types

    cpdef int32_t to_i32(self):
        return cfloat.f64_to_i32(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef uint32_t to_ui32(self):
        return cfloat.f64_to_ui32(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef int64_t to_i64(self):
        return cfloat.f64_to_i64(self._c_float, cfloat.softfloat_roundingMode, True)

    cpdef uint64_t to_ui64(self):
        return cfloat.f64_to_ui64(self._c_float, cfloat.softfloat_roundingMode, True)

# external, non-method arithmetic

cpdef Float64 f64_neg(Float64 a1):
    cdef cfloat.float64_t f = _f64_neg(a1._c_float)
    return Float64.from_c_float(f)

cpdef Float64 f64_abs(Float64 a1):
    cdef cfloat.float64_t f = _f64_abs(a1._c_float)
    return Float64.from_c_float(f)

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

cpdef Float64 f64_fma(Float64 acc, Float64 a1, Float64 a2):
    cdef cfloat.float64_t f = cfloat.f64_mulAdd(a1._c_float, a2._c_float, acc._c_float)
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

# u/i32 <-> f64

cpdef Float64 i32_to_f64(int32_t value):
    cdef cfloat.float64_t f = cfloat.i32_to_f64(value)
    return Float64.from_c_float(f)

cpdef Float64 ui32_to_f64(uint32_t value):
    cdef cfloat.float64_t f = cfloat.ui32_to_f64(value)
    return Float64.from_c_float(f)

cpdef int32_t f64_to_i32(Float64 a1):
    return cfloat.f64_to_i32(a1._c_float, cfloat.softfloat_roundingMode, True)

cpdef uint32_t f64_to_ui32(Float64 a1):
    return cfloat.f64_to_ui32(a1._c_float, cfloat.softfloat_roundingMode, True)

# u/i64 <-> f64

cpdef Float64 i64_to_f64(int64_t value):
    cdef cfloat.float64_t f = cfloat.i64_to_f64(value)
    return Float64.from_c_float(f)

cpdef Float64 ui64_to_f64(uint64_t value):
    cdef cfloat.float64_t f = cfloat.ui64_to_f64(value)
    return Float64.from_c_float(f)

cpdef int64_t f64_to_i64(Float64 a1):
    return cfloat.f64_to_i64(a1._c_float, cfloat.softfloat_roundingMode, True)

cpdef uint64_t f64_to_ui64(Float64 a1):
    return cfloat.f64_to_ui64(a1._c_float, cfloat.softfloat_roundingMode, True)
