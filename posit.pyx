cimport cposit

cdef class Posit8:
    cdef cposit.posit8_t _c_posit

    def __cinit__(self):
        self._c_posit = cposit.i64_to_p8(1)

    cpdef show(self):
        print(cposit.p8_to_i64(self._c_posit))
    
