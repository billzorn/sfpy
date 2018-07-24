from libc.stdint cimport *

cdef extern from 'SoftPosit/source/include/softposit.h':

    ctypedef struct posit8_t:
        pass

    posit8_t  i64_to_p8( int64_t );
    int_fast64_t p8_to_i64( posit8_t);
