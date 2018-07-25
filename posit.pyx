cimport cposit

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
    def from_bits(int value):
        """Factory function to create a Posit8 object from a bit pattern
        represented as an integer.
        """
        cdef Posit8 obj = Posit8.__new__(Posit8)
        obj._c_posit = cposit.castP8(value)
        return obj

    @staticmethod
    def from_double(float value):
        """Factory function to create a Posit8 object from a double.
        """
        cdef Posit8 obj = Posit8.__new__(Posit8)
        obj._c_posit = cposit.convertDoubleToP8(value)
        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        if isinstance(value, int):
            self._c_posit = cposit.castP8(value)
        else:
            f = float(value)
            self._c_posit = cposit.convertDoubleToP8(f)

    def __str__(self):
        return repr(cposit.convertP8ToDouble(self._c_posit))

    def __repr__(self):
        return 'Posit8(' + repr(cposit.convertP8ToDouble(self._c_posit)) + ')'

    cpdef get_bits(self):
        cdef int u = cposit.castUI8(self._c_posit)
        return u
    bits = property(get_bits)

    # arithmetic

    cpdef round(self):
        cdef cposit.posit8_t f = cposit.p8_roundToInt(self._c_posit)
        return Posit8.from_c_posit(f)

    def __round__(self, Posit8 other):
        return self.roundToInt(other)

    cpdef add(self, Posit8 other):
        cdef cposit.posit8_t f = cposit.p8_add(self._c_posit, other._c_posit)
        return Posit8.from_c_posit(f)

    def __add__(self, Posit8 other):
        return self.add(other)

    cpdef sub(self, Posit8 other):
        cdef cposit.posit8_t f = cposit.p8_sub(self._c_posit, other._c_posit)
        return Posit8.from_c_posit(f)

    def __sub__(self, Posit8 other):
        return self.sub(other)

    cpdef mul(self, Posit8 other):
        cdef cposit.posit8_t f = cposit.p8_mul(self._c_posit, other._c_posit)
        return Posit8.from_c_posit(f)

    def __mul__(self, Posit8 other):
        return self.mul(other)

    cpdef fma(self, Posit8 a2, Posit8 a3):
      cdef cposit.posit8_t f = cposit.p8_mulAdd(self._c_posit, a2._c_posit, a3._c_posit)
      return Posit8.from_c_posit(f)

    cpdef div(self, Posit8 other):
        cdef cposit.posit8_t f = cposit.p8_div(self._c_posit, other._c_posit)
        return Posit8.from_c_posit(f)

    def __truediv__(self, Posit8 other):
        return self.div(other)

    cpdef sqrt(self):
        cdef cposit.posit8_t f = cposit.p8_sqrt(self._c_posit)
        return Posit8.from_c_posit(f)

    # in-place arithmetic

    cpdef iround(self):
        self._c_posit = cposit.p8_roundToInt(self._c_posit)

    cpdef iadd(self, Posit8 other):
        self._c_posit = cposit.p8_add(self._c_posit, other._c_posit)

    def __iadd__(self, Posit8 other):
        self.iadd(other)
        return self

    cpdef isub(self, Posit8 other):
        self._c_posit = cposit.p8_sub(self._c_posit, other._c_posit)

    def __isub__(self, Posit8 other):
        self.isub(other)
        return self

    cpdef imul(self, Posit8 other):
        self._c_posit = cposit.p8_mul(self._c_posit, other._c_posit)

    def __imul__(self, Posit8 other):
        self.imul(other)
        return self

    cpdef ifma(self, Posit8 a2, Posit8 a3):
        self._c_posit = cposit.p8_mulAdd(self._c_posit, a2._c_posit, a3._c_posit)

    cpdef idiv(self, Posit8 other):
        self._c_posit = cposit.p8_div(self._c_posit, other._c_posit)

    def __itruediv__(self, Posit8 other):
        self.idiv(other)
        return self

    cpdef isqrt(self):
        self._c_posit = cposit.p8_sqrt(self._c_posit)

    # comparison

    cpdef eq(self, Posit8 other):
        cdef bint b = cposit.p8_eq(self._c_posit, other._c_posit)
        return b

    cpdef le(self, Posit8 other):
        cdef bint b = cposit.p8_le(self._c_posit, other._c_posit)
        return b

    cpdef lt(self, Posit8 other):
        cdef bint b = cposit.p8_lt(self._c_posit, other._c_posit)
        return b

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


cdef class Quire8:

    # the wrapped quire value
    cdef cposit.quire8_t _c_quire

    # limited interface for now

    def __cinit__(self):
        cposit.q8_clr(self._c_quire)

    def __str__(self):
        return repr(cposit.convertP8ToDouble(cposit.q8_to_p8(self._c_quire)))

    def __repr__(self):
        return 'Quire8(' + repr(cposit.convertP8ToDouble(cposit.q8_to_p8(self._c_quire))) + ')'

    cpdef fdp_add(self, Posit8 a2, Posit8 a3):
        self._c_quire = cposit.q8_fdp_add(self._c_quire, a2._c_posit, a3._c_posit)

    cpdef fdp_sub(self, Posit8 a2, Posit8 a3):
        self._c_quire = cposit.q8_fdp_sub(self._c_quire, a2._c_posit, a3._c_posit)

    cpdef get_p8(self):
        cpdef cposit.posit8_t f = cposit.q8_to_p8(self._c_quire)
        return Posit8.from_c_posit(f)
    p8 = property(get_p8)


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
    def from_bits(int value):
        """Factory function to create a Posit16 object from a bit pattern
        represented as an integer.
        """
        cdef Posit16 obj = Posit16.__new__(Posit16)
        obj._c_posit = cposit.castP16(value)
        return obj

    @staticmethod
    def from_double(float value):
        """Factory function to create a Posit16 object from a double.
        """
        cdef Posit16 obj = Posit16.__new__(Posit16)
        obj._c_posit = cposit.convertDoubleToP16(value)
        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        if isinstance(value, int):
            self._c_posit = cposit.castP16(value)
        else:
            f = float(value)
            self._c_posit = cposit.convertDoubleToP16(f)

    def __str__(self):
        return repr(cposit.convertP16ToDouble(self._c_posit))

    def __repr__(self):
        return 'Posit16(' + repr(cposit.convertP16ToDouble(self._c_posit)) + ')'

    cpdef get_bits(self):
        cdef int u = cposit.castUI16(self._c_posit)
        return u
    bits = property(get_bits)

    # arithmetic

    cpdef round(self):
        cdef cposit.posit16_t f = cposit.p16_roundToInt(self._c_posit)
        return Posit16.from_c_posit(f)

    def __round__(self, Posit16 other):
        return self.roundToInt(other)

    cpdef add(self, Posit16 other):
        cdef cposit.posit16_t f = cposit.p16_add(self._c_posit, other._c_posit)
        return Posit16.from_c_posit(f)

    def __add__(self, Posit16 other):
        return self.add(other)

    cpdef sub(self, Posit16 other):
        cdef cposit.posit16_t f = cposit.p16_sub(self._c_posit, other._c_posit)
        return Posit16.from_c_posit(f)

    def __sub__(self, Posit16 other):
        return self.sub(other)

    cpdef mul(self, Posit16 other):
        cdef cposit.posit16_t f = cposit.p16_mul(self._c_posit, other._c_posit)
        return Posit16.from_c_posit(f)

    def __mul__(self, Posit16 other):
        return self.mul(other)

    cpdef fma(self, Posit16 a2, Posit16 a3):
      cdef cposit.posit16_t f = cposit.p16_mulAdd(self._c_posit, a2._c_posit, a3._c_posit)
      return Posit16.from_c_posit(f)

    cpdef div(self, Posit16 other):
        cdef cposit.posit16_t f = cposit.p16_div(self._c_posit, other._c_posit)
        return Posit16.from_c_posit(f)

    def __truediv__(self, Posit16 other):
        return self.div(other)

    cpdef sqrt(self):
        cdef cposit.posit16_t f = cposit.p16_sqrt(self._c_posit)
        return Posit16.from_c_posit(f)

    # in-place arithmetic

    cpdef iround(self):
        self._c_posit = cposit.p16_roundToInt(self._c_posit)

    cpdef iadd(self, Posit16 other):
        self._c_posit = cposit.p16_add(self._c_posit, other._c_posit)

    def __iadd__(self, Posit16 other):
        self.iadd(other)
        return self

    cpdef isub(self, Posit16 other):
        self._c_posit = cposit.p16_sub(self._c_posit, other._c_posit)

    def __isub__(self, Posit16 other):
        self.isub(other)
        return self

    cpdef imul(self, Posit16 other):
        self._c_posit = cposit.p16_mul(self._c_posit, other._c_posit)

    def __imul__(self, Posit16 other):
        self.imul(other)
        return self

    cpdef ifma(self, Posit16 a2, Posit16 a3):
        self._c_posit = cposit.p16_mulAdd(self._c_posit, a2._c_posit, a3._c_posit)

    cpdef idiv(self, Posit16 other):
        self._c_posit = cposit.p16_div(self._c_posit, other._c_posit)

    def __itruediv__(self, Posit16 other):
        self.idiv(other)
        return self

    cpdef isqrt(self):
        self._c_posit = cposit.p16_sqrt(self._c_posit)

    # comparison

    cpdef eq(self, Posit16 other):
        cdef bint b = cposit.p16_eq(self._c_posit, other._c_posit)
        return b

    cpdef le(self, Posit16 other):
        cdef bint b = cposit.p16_le(self._c_posit, other._c_posit)
        return b

    cpdef lt(self, Posit16 other):
        cdef bint b = cposit.p16_lt(self._c_posit, other._c_posit)
        return b

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


cdef class Quire16:

    # the wrapped quire value
    cdef cposit.quire16_t _c_quire

    # limited interface for now

    def __cinit__(self):
        cposit.q16_clr(self._c_quire)

    def __str__(self):
        return repr(cposit.convertP16ToDouble(cposit.q16_to_p16(self._c_quire)))

    def __repr__(self):
        return 'Quire16(' + repr(cposit.convertP16ToDouble(cposit.q16_to_p16(self._c_quire))) + ')'

    cpdef fdp_add(self, Posit16 a2, Posit16 a3):
        self._c_quire = cposit.q16_fdp_add(self._c_quire, a2._c_posit, a3._c_posit)

    cpdef fdp_sub(self, Posit16 a2, Posit16 a3):
        self._c_quire = cposit.q16_fdp_sub(self._c_quire, a2._c_posit, a3._c_posit)

    cpdef get_p16(self):
        cpdef cposit.posit16_t f = cposit.q16_to_p16(self._c_quire)
        return Posit16.from_c_posit(f)
    p16 = property(get_p16)
