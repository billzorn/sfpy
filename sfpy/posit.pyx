from libc.stdint cimport *
cimport cposit


# special values needed for some initializations

cdef posit8_one = cposit.ui32_to_p8(1)
cdef posit16_one = cposit.ui32_to_p16(1)


cdef class Posit8:

    # the wrapped posit value
    cdef cposit.posit8_t _c_posit

    # factory function constructors that bypass __init__

    @staticmethod
    cdef Posit8 from_c_posit(cposit.posit8_t f):
        """Factory function to create a Posit8 object directly from
        a C posit8_t.
        """
        cdef Posit8 obj = Posit8.__new__(Posit8)
        obj._c_posit = f
        return obj

    @staticmethod
    def from_bits(uint8_t value):
        """Factory function to create a Posit8 object from a bit pattern
        represented as an integer.
        """
        cdef Posit8 obj = Posit8.__new__(Posit8)
        obj._c_posit.v = value
        return obj

    @staticmethod
    def from_double(double value):
        """Factory function to create a Posit8 object from a double.
        """
        cdef Posit8 obj = Posit8.__new__(Posit8)
        obj._c_posit = cposit.convertDoubleToP8(value)
        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        if isinstance(value, int):
            self._c_posit.v = value
        else:
            f = float(value)
            self._c_posit = cposit.convertDoubleToP8(f)

    def __float__(self):
        return cposit.convertP8ToDouble(self._c_posit)

    def __int__(self):
        return int(cposit.convertP8ToDouble(self._c_posit))

    def __str__(self):
        return repr(cposit.convertP8ToDouble(self._c_posit))

    def __repr__(self):
        return 'Posit8(' + repr(cposit.convertP8ToDouble(self._c_posit)) + ')'

    cpdef uint8_t get_bits(self):
        return self._c_posit.v
    bits = property(get_bits)

    # arithmetic

    cpdef Posit8 round(self):
        cdef cposit.posit8_t f = cposit.p8_roundToInt(self._c_posit)
        return Posit8.from_c_posit(f)

    def __round__(self):
        return self.roundToInt()

    cpdef Posit8 add(self, Posit8 other):
        cdef cposit.posit8_t f = cposit.p8_add(self._c_posit, other._c_posit)
        return Posit8.from_c_posit(f)

    def __add__(self, Posit8 other):
        return self.add(other)

    cpdef Posit8 sub(self, Posit8 other):
        cdef cposit.posit8_t f = cposit.p8_sub(self._c_posit, other._c_posit)
        return Posit8.from_c_posit(f)

    def __sub__(self, Posit8 other):
        return self.sub(other)

    cpdef Posit8 mul(self, Posit8 other):
        cdef cposit.posit8_t f = cposit.p8_mul(self._c_posit, other._c_posit)
        return Posit8.from_c_posit(f)

    def __mul__(self, Posit8 other):
        return self.mul(other)

    cpdef Posit8 fma(self, Posit8 a2, Posit8 a3):
        cdef cposit.posit8_t f = cposit.p8_mulAdd(self._c_posit, a2._c_posit, a3._c_posit)
        return Posit8.from_c_posit(f)

    cpdef Posit8 qma(self, Posit8 a1, Posit8 a2):
        cdef cposit.posit8_t f = cposit.p8_mulAdd(a1._c_posit, a2._c_posit, self._c_posit)
        return Posit8.from_c_posit(f)

    cpdef Posit8 div(self, Posit8 other):
        cdef cposit.posit8_t f = cposit.p8_div(self._c_posit, other._c_posit)
        return Posit8.from_c_posit(f)

    def __truediv__(self, Posit8 other):
        return self.div(other)

    cpdef Posit8 sqrt(self):
        cdef cposit.posit8_t f = cposit.p8_sqrt(self._c_posit)
        return Posit8.from_c_posit(f)

    # in-place arithmetic

    cpdef void iround(self):
        self._c_posit = cposit.p8_roundToInt(self._c_posit)

    cpdef void iadd(self, Posit8 other):
        self._c_posit = cposit.p8_add(self._c_posit, other._c_posit)

    def __iadd__(self, Posit8 other):
        self.iadd(other)
        return self

    cpdef void isub(self, Posit8 other):
        self._c_posit = cposit.p8_sub(self._c_posit, other._c_posit)

    def __isub__(self, Posit8 other):
        self.isub(other)
        return self

    cpdef void imul(self, Posit8 other):
        self._c_posit = cposit.p8_mul(self._c_posit, other._c_posit)

    def __imul__(self, Posit8 other):
        self.imul(other)
        return self

    cpdef void ifma(self, Posit8 a2, Posit8 a3):
        self._c_posit = cposit.p8_mulAdd(self._c_posit, a2._c_posit, a3._c_posit)

    cpdef void iqma(self, Posit8 a1, Posit8 a2):
        self._c_posit = cposit.p8_mulAdd(a1._c_posit, a2._c_posit, self._c_posit)

    cpdef void idiv(self, Posit8 other):
        self._c_posit = cposit.p8_div(self._c_posit, other._c_posit)

    def __itruediv__(self, Posit8 other):
        self.idiv(other)
        return self

    cpdef void isqrt(self):
        self._c_posit = cposit.p8_sqrt(self._c_posit)

    # comparison

    cpdef bint eq(self, Posit8 other):
        return cposit.p8_eq(self._c_posit, other._c_posit)

    cpdef bint le(self, Posit8 other):
        return cposit.p8_le(self._c_posit, other._c_posit)

    cpdef bint lt(self, Posit8 other):
        return cposit.p8_lt(self._c_posit, other._c_posit)

    def __lt__(self, Posit8 other):
        return self.lt(other)

    def __le__(self, Posit8 other):
        return self.le(other)

    def __eq__(self, Posit8 other):
        return self.eq(other)

    def __ne__(self, Posit8 other):
        return not self.eq(other)

    def __ge__(self, Posit8 other):
        return other.le(self)

    def __gt__(self, Posit8 other):
        return other.lt(self)

    # conversion to other posit types

    cpdef to_p16(self):
        cdef cposit.posit16_t f = cposit.p8_to_p16(self._c_posit)
        return Posit16.from_c_posit(f)

    cpdef to_quire(self):
        cdef cposit.quire8_t f
        cposit.q8_clr(f)
        f = cposit.q8_fdp_add(f, self._c_posit, posit8_one)
        return Quire8.from_c_quire(f)


cdef class Quire8:

    # the wrapped quire value
    cdef cposit.quire8_t _c_quire

    # factory function constructors that bypass init

    @staticmethod
    cdef Quire8 from_c_quire(cposit.quire8_t f):
        """Factory function to create a Quire8 object directly from
        a C quire8_t.
        """
        cdef Quire8 obj = Quire8.__new__(Quire8)
        obj._c_quire = f
        return obj

    @staticmethod
    def from_bits(uint32_t value):
        """Factory function to create a Quire8 object from a bit pattern
        represented as an integer.
        """
        cdef Quire8 obj = Quire8.__new__(Quire8)
        obj._c_quire.v = value
        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        if isinstance(value, int):
            self._c_quire.v = value
        else:
            f = float(value)
            cposit.q8_clr(self._c_quire)
            self._c_quire = cposit.q8_fdp_add(self._c_quire, cposit.convertDoubleToP8(f), posit8_one)

    def __float__(self):
        return cposit.convertP8ToDouble(cposit.q8_to_p8(self._c_quire))

    def __int__(self):
        return int(cposit.convertP8ToDouble(cposit.q8_to_p8(self._c_quire)))

    def __str__(self):
        return repr(cposit.convertP8ToDouble(cposit.q8_to_p8(self._c_quire)))

    def __repr__(self):
        return 'Quire8(' + repr(cposit.convertP8ToDouble(cposit.q8_to_p8(self._c_quire))) + ')'

    cpdef uint32_t get_bits(self):
        return self._c_quire.v
    bits = property(get_bits)

    # arithmetic

    cpdef Quire8 qma(self, Posit8 a1, Posit8 a2):
        cdef cposit.quire8_t f = cposit.q8_fdp_add(self._c_quire, a1._c_posit, a2._c_posit)
        return Quire8.from_c_quire(f)

    cpdef Quire8 qms(self, Posit8 a1, Posit8 a2):
        cdef cposit.quire8_t f = cposit.q8_fdp_sub(self._c_quire, a1._c_posit, a2._c_posit)
        return Quire8.from_c_quire(f)

    cpdef void iqma(self, Posit8 a1, Posit8 a2):
        self._c_quire = cposit.q8_fdp_add(self._c_quire, a1._c_posit, a2._c_posit)

    cpdef void iqms(self, Posit8 a1, Posit8 a2):
        self._c_quire = cposit.q8_fdp_sub(self._c_quire, a1._c_posit, a2._c_posit)

    cpdef void iclr(self):
        cposit.q8_clr(self._c_quire)

    # conversion back to posit

    cpdef Posit8 to_posit(self):
        cpdef cposit.posit8_t f = cposit.q8_to_p8(self._c_quire)
        return Posit8.from_c_posit(f)


# external, non-method arithmetic

cpdef Posit8 p8_round(Posit8 a1):
    cdef cposit.posit8_t f = cposit.p8_roundToInt(a1._c_posit)
    return Posit8.from_c_posit(f)

cpdef Posit8 p8_add(Posit8 a1, Posit8 a2):
    cdef cposit.posit8_t f = cposit.p8_add(a1._c_posit, a2._c_posit)
    return Posit8.from_c_posit(f)

cpdef Posit8 p8_sub(Posit8 a1, Posit8 a2):
    cdef cposit.posit8_t f = cposit.p8_sub(a1._c_posit, a2._c_posit)
    return Posit8.from_c_posit(f)

cpdef Posit8 p8_mul(Posit8 a1, Posit8 a2):
    cdef cposit.posit8_t f = cposit.p8_mul(a1._c_posit, a2._c_posit)
    return Posit8.from_c_posit(f)

cpdef Posit8 p8_fma(Posit8 a1, Posit8 a2, Posit8 a3):
    cdef cposit.posit8_t f = cposit.p8_mulAdd(a1._c_posit, a2._c_posit, a3._c_posit)
    return Posit8.from_c_posit(f)

cpdef Posit8 p8_qma(Posit8 a3, Posit8 a1, Posit8 a2):
    cdef cposit.posit8_t f = cposit.p8_mulAdd(a1._c_posit, a2._c_posit, a3._c_posit)
    return Posit8.from_c_posit(f)

cpdef Posit8 p8_div(Posit8 a1, Posit8 a2):
    cdef cposit.posit8_t f = cposit.p8_div(a1._c_posit, a2._c_posit)
    return Posit8.from_c_posit(f)

cpdef Posit8 p8_sqrt(Posit8 a1):
    cdef cposit.posit8_t f = cposit.p8_sqrt(a1._c_posit)
    return Posit8.from_c_posit(f)

cpdef bint p8_eq(Posit8 a1, Posit8 a2):
    return cposit.p8_eq(a1._c_posit, a2._c_posit)

cpdef bint p8_le(Posit8 a1, Posit8 a2):
    return cposit.p8_le(a1._c_posit, a2._c_posit)

cpdef bint p8_lt(Posit8 a1, Posit8 a2):
    return cposit.p8_lt(a1._c_posit, a2._c_posit)

cpdef Posit16 p8_to_p16(Posit8 a1):
    cdef cposit.posit16_t f = cposit.p8_to_p16(a1._c_posit)
    return Posit16.from_c_posit(f)

cpdef Quire8 p8_to_q8(Posit8 a1):
    cdef cposit.quire8_t f
    cposit.q8_clr(f)
    f = cposit.q8_fdp_add(f, a1._c_posit, posit8_one)
    return Quire8.from_c_quire(f)

cpdef Quire8 q8_qma(Quire8 a3, Posit8 a1, Posit8 a2):
    cdef cposit.quire8_t f = cposit.q8_fdp_add(a3._c_quire, a1._c_posit, a2._c_posit)
    return Quire8.from_c_quire(f)

cpdef Quire8 q8_qms(Quire8 a3, Posit8 a1, Posit8 a2):
    cdef cposit.quire8_t f = cposit.q8_fdp_sub(a3._c_quire, a1._c_posit, a2._c_posit)
    return Quire8.from_c_quire(f)

cpdef Posit8 q8_to_p8(Quire8 a1):
    cpdef cposit.posit8_t f = cposit.q8_to_p8(a1._c_quire)
    return Posit8.from_c_posit(f)


cdef class Posit16:

    # the wrapped posit value
    cdef cposit.posit16_t _c_posit

    # factory function constructors that bypass __init__

    @staticmethod
    cdef Posit16 from_c_posit(cposit.posit16_t f):
        """Factory function to create a Posit16 object directly from
        a C posit16_t.
        """
        cdef Posit16 obj = Posit16.__new__(Posit16)
        obj._c_posit = f
        return obj

    @staticmethod
    def from_bits(uint16_t value):
        """Factory function to create a Posit16 object from a bit pattern
        represented as an integer.
        """
        cdef Posit16 obj = Posit16.__new__(Posit16)
        obj._c_posit.v = value
        return obj

    @staticmethod
    def from_double(double value):
        """Factory function to create a Posit16 object from a double.
        """
        cdef Posit16 obj = Posit16.__new__(Posit16)
        obj._c_posit = cposit.convertDoubleToP16(value)
        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        if isinstance(value, int):
            self._c_posit.v = value
        else:
            f = float(value)
            self._c_posit = cposit.convertDoubleToP16(f)

    def __float__(self):
        return cposit.convertP16ToDouble(self._c_posit)

    def __int__(self):
        return int(cposit.convertP16ToDouble(self._c_posit))

    def __str__(self):
        return repr(cposit.convertP16ToDouble(self._c_posit))

    def __repr__(self):
        return 'Posit16(' + repr(cposit.convertP16ToDouble(self._c_posit)) + ')'

    cpdef uint16_t get_bits(self):
        return self._c_posit.v
    bits = property(get_bits)

    # arithmetic

    cpdef Posit16 round(self):
        cdef cposit.posit16_t f = cposit.p16_roundToInt(self._c_posit)
        return Posit16.from_c_posit(f)

    def __round__(self):
        return self.roundToInt()

    cpdef Posit16 add(self, Posit16 other):
        cdef cposit.posit16_t f = cposit.p16_add(self._c_posit, other._c_posit)
        return Posit16.from_c_posit(f)

    def __add__(self, Posit16 other):
        return self.add(other)

    cpdef Posit16 sub(self, Posit16 other):
        cdef cposit.posit16_t f = cposit.p16_sub(self._c_posit, other._c_posit)
        return Posit16.from_c_posit(f)

    def __sub__(self, Posit16 other):
        return self.sub(other)

    cpdef Posit16 mul(self, Posit16 other):
        cdef cposit.posit16_t f = cposit.p16_mul(self._c_posit, other._c_posit)
        return Posit16.from_c_posit(f)

    def __mul__(self, Posit16 other):
        return self.mul(other)

    cpdef Posit16 fma(self, Posit16 a2, Posit16 a3):
        cdef cposit.posit16_t f = cposit.p16_mulAdd(self._c_posit, a2._c_posit, a3._c_posit)
        return Posit16.from_c_posit(f)

    cpdef Posit16 qma(self, Posit16 a1, Posit16 a2):
        cdef cposit.posit16_t f = cposit.p16_mulAdd(a1._c_posit, a2._c_posit, self._c_posit)
        return Posit16.from_c_posit(f)

    cpdef Posit16 div(self, Posit16 other):
        cdef cposit.posit16_t f = cposit.p16_div(self._c_posit, other._c_posit)
        return Posit16.from_c_posit(f)

    def __truediv__(self, Posit16 other):
        return self.div(other)

    cpdef Posit16 sqrt(self):
        cdef cposit.posit16_t f = cposit.p16_sqrt(self._c_posit)
        return Posit16.from_c_posit(f)

    # in-place arithmetic

    cpdef void iround(self):
        self._c_posit = cposit.p16_roundToInt(self._c_posit)

    cpdef void iadd(self, Posit16 other):
        self._c_posit = cposit.p16_add(self._c_posit, other._c_posit)

    def __iadd__(self, Posit16 other):
        self.iadd(other)
        return self

    cpdef void isub(self, Posit16 other):
        self._c_posit = cposit.p16_sub(self._c_posit, other._c_posit)

    def __isub__(self, Posit16 other):
        self.isub(other)
        return self

    cpdef void imul(self, Posit16 other):
        self._c_posit = cposit.p16_mul(self._c_posit, other._c_posit)

    def __imul__(self, Posit16 other):
        self.imul(other)
        return self

    cpdef void ifma(self, Posit16 a2, Posit16 a3):
        self._c_posit = cposit.p16_mulAdd(self._c_posit, a2._c_posit, a3._c_posit)

    cpdef void iqma(self, Posit16 a1, Posit16 a2):
        self._c_posit = cposit.p16_mulAdd(a1._c_posit, a2._c_posit, self._c_posit)

    cpdef void idiv(self, Posit16 other):
        self._c_posit = cposit.p16_div(self._c_posit, other._c_posit)

    def __itruediv__(self, Posit16 other):
        self.idiv(other)
        return self

    cpdef void isqrt(self):
        self._c_posit = cposit.p16_sqrt(self._c_posit)

    # comparison

    cpdef bint eq(self, Posit16 other):
        return cposit.p16_eq(self._c_posit, other._c_posit)

    cpdef bint le(self, Posit16 other):
        return cposit.p16_le(self._c_posit, other._c_posit)

    cpdef bint lt(self, Posit16 other):
        return cposit.p16_lt(self._c_posit, other._c_posit)

    def __lt__(self, Posit16 other):
        return self.lt(other)

    def __le__(self, Posit16 other):
        return self.le(other)

    def __eq__(self, Posit16 other):
        return self.eq(other)

    def __ne__(self, Posit16 other):
        return not self.eq(other)

    def __ge__(self, Posit16 other):
        return other.le(self)

    def __gt__(self, Posit16 other):
        return other.lt(self)

    # conversion to other posit types

    cpdef to_p8(self):
        cdef cposit.posit8_t f = cposit.p16_to_p8(self._c_posit)
        return Posit8.from_c_posit(f)

    cpdef to_quire(self):
        cdef cposit.quire16_t f
        cposit.q16_clr(f)
        f = cposit.q16_fdp_add(f, self._c_posit, posit16_one)
        return Quire16.from_c_quire(f)


cdef class Quire16:

    # the wrapped quire value
    cdef cposit.quire16_t _c_quire

    # factory function constructors that bypass init

    @staticmethod
    cdef Quire16 from_c_quire(cposit.quire16_t f):
        """Factory function to create a Quire16 object directly from
        a C quire16_t.
        """
        cdef Quire16 obj = Quire16.__new__(Quire16)
        obj._c_quire = f
        return obj

    @staticmethod
    def from_bits(value):
        """Factory function to create a Quire16 object from a bit pattern
        represented as an integer.
        """
        cdef Quire16 obj = Quire16.__new__(Quire16)

        if not isinstance(value, int):
            raise TypeError('expecting int, got {}'.format(repr(value)))

        for idx in range(1, -1, -1):
            obj._c_quire.v[idx] = value & 0xffffffffffffffff
            value >>= 64

        if not (value == 0):
            raise OverflowError('value too large to fit in uint64_t[2]')

        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        if isinstance(value, int):
            for idx in range(1, -1, -1):
                self._c_quire.v[idx] = value & 0xffffffffffffffff
                value >>= 64
            if not (value == 0):
                raise OverflowError('value too large to fit in uint64_t[2]')
        else:
            f = float(value)
            cposit.q16_clr(self._c_quire)
            self._c_quire = cposit.q16_fdp_add(self._c_quire, cposit.convertDoubleToP16(f), posit16_one)

    def __float__(self):
        return cposit.convertP16ToDouble(cposit.q16_to_p16(self._c_quire))

    def __int__(self):
        return int(cposit.convertP16ToDouble(cposit.q16_to_p16(self._c_quire)))

    def __str__(self):
        return repr(cposit.convertP16ToDouble(cposit.q16_to_p16(self._c_quire)))

    def __repr__(self):
        return 'Quire16(' + repr(cposit.convertP16ToDouble(cposit.q16_to_p16(self._c_quire))) + ')'

    def get_bits(self):
        b = 0
        for u in self._c_quire.v:
            b <<= 64
            b |= u
        return b
    bits = property(get_bits)

    # arithmetic

    cpdef Quire16 qma(self, Posit16 a1, Posit16 a2):
        cdef cposit.quire16_t f = cposit.q16_fdp_add(self._c_quire, a1._c_posit, a2._c_posit)
        return Quire16.from_c_quire(f)

    cpdef Quire16 qms(self, Posit16 a1, Posit16 a2):
        cdef cposit.quire16_t f = cposit.q16_fdp_sub(self._c_quire, a1._c_posit, a2._c_posit)
        return Quire16.from_c_quire(f)

    cpdef void iqma(self, Posit16 a1, Posit16 a2):
        self._c_quire = cposit.q16_fdp_add(self._c_quire, a1._c_posit, a2._c_posit)

    cpdef void iqms(self, Posit16 a1, Posit16 a2):
        self._c_quire = cposit.q16_fdp_sub(self._c_quire, a1._c_posit, a2._c_posit)

    cpdef void iclr(self):
        cposit.q16_clr(self._c_quire)

    # conversion back to posit

    cpdef Posit16 to_posit(self):
        cpdef cposit.posit16_t f = cposit.q16_to_p16(self._c_quire)
        return Posit16.from_c_posit(f)


# external, non-method arithmetic

cpdef Posit16 p16_round(Posit16 a1):
    cdef cposit.posit16_t f = cposit.p16_roundToInt(a1._c_posit)
    return Posit16.from_c_posit(f)

cpdef Posit16 p16_add(Posit16 a1, Posit16 a2):
    cdef cposit.posit16_t f = cposit.p16_add(a1._c_posit, a2._c_posit)
    return Posit16.from_c_posit(f)

cpdef Posit16 p16_sub(Posit16 a1, Posit16 a2):
    cdef cposit.posit16_t f = cposit.p16_sub(a1._c_posit, a2._c_posit)
    return Posit16.from_c_posit(f)

cpdef Posit16 p16_mul(Posit16 a1, Posit16 a2):
    cdef cposit.posit16_t f = cposit.p16_mul(a1._c_posit, a2._c_posit)
    return Posit16.from_c_posit(f)

cpdef Posit16 p16_fma(Posit16 a1, Posit16 a2, Posit16 a3):
    cdef cposit.posit16_t f = cposit.p16_mulAdd(a1._c_posit, a2._c_posit, a3._c_posit)
    return Posit16.from_c_posit(f)

cpdef Posit16 p16_qma(Posit16 a3, Posit16 a1, Posit16 a2):
    cdef cposit.posit16_t f = cposit.p16_mulAdd(a1._c_posit, a2._c_posit, a3._c_posit)
    return Posit16.from_c_posit(f)

cpdef Posit16 p16_div(Posit16 a1, Posit16 a2):
    cdef cposit.posit16_t f = cposit.p16_div(a1._c_posit, a2._c_posit)
    return Posit16.from_c_posit(f)

cpdef Posit16 p16_sqrt(Posit16 a1):
    cdef cposit.posit16_t f = cposit.p16_sqrt(a1._c_posit)
    return Posit16.from_c_posit(f)

cpdef bint p16_eq(Posit16 a1, Posit16 a2):
    return cposit.p16_eq(a1._c_posit, a2._c_posit)

cpdef bint p16_le(Posit16 a1, Posit16 a2):
    return cposit.p16_le(a1._c_posit, a2._c_posit)

cpdef bint p16_lt(Posit16 a1, Posit16 a2):
    return cposit.p16_lt(a1._c_posit, a2._c_posit)

cpdef Posit8 p16_to_p8(Posit16 a1):
    cdef cposit.posit8_t f = cposit.p16_to_p8(a1._c_posit)
    return Posit8.from_c_posit(f)

cpdef Quire16 p16_to_q16(Posit16 a1):
    cdef cposit.quire16_t f
    cposit.q16_clr(f)
    f = cposit.q16_fdp_add(f, a1._c_posit, posit16_one)
    return Quire16.from_c_quire(f)

cpdef Quire16 q16_qma(Quire16 a3, Posit16 a1, Posit16 a2):
    cdef cposit.quire16_t f = cposit.q16_fdp_add(a3._c_quire, a1._c_posit, a2._c_posit)
    return Quire16.from_c_quire(f)

cpdef Quire16 q16_qms(Quire16 a3, Posit16 a1, Posit16 a2):
    cdef cposit.quire16_t f = cposit.q16_fdp_sub(a3._c_quire, a1._c_posit, a2._c_posit)
    return Quire16.from_c_quire(f)

cpdef Posit16 q16_to_p16(Quire16 a1):
    cpdef cposit.posit16_t f = cposit.q16_to_p16(a1._c_quire)
    return Posit16.from_c_posit(f)
