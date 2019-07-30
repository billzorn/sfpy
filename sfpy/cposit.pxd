from libc.stdint cimport *

# As far as I can tell, this is never enabled when the library is comiled...
# The option will have to be synced manually, as by the time Cython's c is
# compiled the library will already be stored as a .a file and any compile-time
# options used to build it will be long gone.
DEF SOFTPOSIT_EXACT = 0

cdef extern from 'include/softposit.h':

    # Transparent types so we can have access to the raw bits.

    IF SOFTPOSIT_EXACT:

        ctypedef struct posit8_t:
            uint8_t v;
            bint exact;

        ctypedef struct quire8_t:
            uint32_t v;
            bint exact;

        ctypedef struct posit16_t:
            uint16_t v;
            bint exact;

        ctypedef struct quire16_t:
            uint64_t v[2];
            bint exact;

        ctypedef struct posit32_t:
            uint32_t v;
            bint exact;

        ctypedef struct quire32_t:
            uint64_t v[8];
            bint exact;

    ELSE:

        ctypedef struct posit8_t:
            uint8_t v;

        ctypedef struct posit16_t:
            uint16_t v;

        ctypedef struct posit32_t:
            uint32_t v;

        ctypedef struct quire8_t:
            uint32_t v;

        ctypedef struct quire16_t:
            uint64_t v[2];

        ctypedef struct quire32_t:
            uint64_t v[8];

    # /*----------------------------------------------------------------------------
    # | Integer-to-posit conversion routines.
    # *----------------------------------------------------------------------------*/

    posit8_t  ui32_to_p8( uint32_t );
    posit16_t ui32_to_p16( uint32_t );
    posit32_t ui32_to_p32( uint32_t );
    # posit64_t ui32_to_p64( uint32_t );

    posit8_t  ui64_to_p8( uint64_t );
    posit16_t ui64_to_p16( uint64_t );
    posit32_t ui64_to_p32( uint64_t );
    # posit64_t ui64_to_p64( uint64_t );

    posit8_t  i32_to_p8( int32_t );
    posit16_t i32_to_p16( int32_t );
    posit32_t i32_to_p32( int32_t );
    # posit64_t i32_to_p64( int32_t );

    posit8_t  i64_to_p8( int64_t );
    posit16_t i64_to_p16( int64_t );
    posit32_t i64_to_p32( int64_t );
    # posit64_t i64_to_p64( int64_t );

    # /*----------------------------------------------------------------------------
    # | 8-bit (quad-precision) posit operations.
    # *----------------------------------------------------------------------------*/

    bint isNaRP8UI( uint8_t );

    uint_fast32_t p8_to_ui32( posit8_t );
    uint_fast64_t p8_to_ui64( posit8_t );
    int_fast32_t p8_to_i32( posit8_t );
    int_fast64_t p8_to_i64( posit8_t );

    posit16_t p8_to_p16( posit8_t );
    posit32_t p8_to_p32( posit8_t );
    # posit64_t p8_to_p64( posit8_t );

    posit8_t p8_roundToInt( posit8_t );
    posit8_t p8_add( posit8_t, posit8_t );
    posit8_t p8_sub( posit8_t, posit8_t );
    posit8_t p8_mul( posit8_t, posit8_t );
    posit8_t p8_mulAdd( posit8_t, posit8_t, posit8_t );
    posit8_t p8_div( posit8_t, posit8_t );
    posit8_t p8_sqrt( posit8_t );
    bint p8_eq( posit8_t, posit8_t );
    bint p8_le( posit8_t, posit8_t );
    bint p8_lt( posit8_t, posit8_t );

    # Quire 8
    quire8_t q8_fdp_add( quire8_t, posit8_t, posit8_t );
    quire8_t q8_fdp_sub( quire8_t, posit8_t, posit8_t );
    posit8_t q8_to_p8( quire8_t );

    bint isNaRQ8( quire8_t );
    bint isQ8Zero( quire8_t );
    #quire8_t q8_clr( quire8_t );
    quire8_t q8Clr();
    quire8_t castQ8( uint32_t );
    posit8_t castP8( uint8_t );
    uint8_t castUI8( posit8_t );
    posit8_t negP8( posit8_t );

    # Helper
    double convertP8ToDouble( posit8_t );
    posit8_t convertDoubleToP8( double );

    # /*----------------------------------------------------------------------------
    # | 16-bit (half-precision) posit operations.
    # *----------------------------------------------------------------------------*/

    bint isNaRP16UI( uint16_t );

    uint_fast32_t p16_to_ui32( posit16_t );
    uint_fast64_t p16_to_ui64( posit16_t );
    int_fast32_t p16_to_i32( posit16_t);
    int_fast64_t p16_to_i64( posit16_t );
    posit8_t p16_to_p8( posit16_t );
    posit32_t p16_to_p32( posit16_t );
    # posit64_t p16_to_p64( posit16_t );

    posit16_t p16_roundToInt( posit16_t);
    posit16_t p16_add( posit16_t, posit16_t );
    posit16_t p16_sub( posit16_t, posit16_t );
    posit16_t p16_mul( posit16_t, posit16_t );
    posit16_t p16_mulAdd( posit16_t, posit16_t, posit16_t );
    posit16_t p16_div( posit16_t, posit16_t );
    posit16_t p16_sqrt( posit16_t );
    bint p16_eq( posit16_t, posit16_t );
    bint p16_le( posit16_t, posit16_t );
    bint p16_lt( posit16_t, posit16_t );

    # Quire 16
    quire16_t q16_fdp_add( quire16_t, posit16_t, posit16_t );
    quire16_t q16_fdp_sub( quire16_t, posit16_t, posit16_t );
    # posit16_t convertQ16ToP16( quire16_t );
    posit16_t q16_to_p16( quire16_t );

    bint isNaRQ16( quire16_t );
    bint isQ16Zero( quire16_t );
    quire16_t q16_TwosComplement( quire16_t );

    # void printBinary( uint64_t*, int );
    # void printHex( uint64_t );

    #quire16_t q16_clr( quire16_t );
    quire16_t q16Clr();
    quire16_t castQ16( uint16_t, uint16_t );
    posit16_t castP16( uint16_t );
    uint16_t castUI16( posit16_t );
    posit16_t negP16( posit16_t );

    # Helper
    double convertP16ToDouble( posit16_t );
    # posit16_t convertFloatToP16( float );
    posit16_t convertDoubleToP16( double );

    # /*----------------------------------------------------------------------------
    # | 32-bit (single-precision) posit operations.
    # *----------------------------------------------------------------------------*/

    bint isNaRP32UI( posit32_t );

    uint_fast32_t p32_to_ui32( posit32_t );
    uint_fast64_t p32_to_ui64( posit32_t);
    int_fast32_t p32_to_i32( posit32_t );
    int_fast64_t p32_to_i64( posit32_t );
    posit8_t p32_to_p8( posit32_t );
    posit16_t p32_to_p16( posit32_t );
    # posit64_t p32_to_p64( posit32_t );

    posit32_t p32_roundToInt( posit32_t );
    posit32_t p32_add( posit32_t, posit32_t );
    posit32_t p32_sub( posit32_t, posit32_t );
    posit32_t p32_mul( posit32_t, posit32_t );
    posit32_t p32_mulAdd( posit32_t, posit32_t, posit32_t );
    posit32_t p32_div( posit32_t, posit32_t );
    posit32_t p32_sqrt( posit32_t );
    bint p32_eq( posit32_t, posit32_t );
    bint p32_le( posit32_t, posit32_t );
    bint p32_lt( posit32_t, posit32_t );

    quire32_t q32_fdp_add( quire32_t, posit32_t, posit32_t );
    quire32_t q32_fdp_sub( quire32_t, posit32_t, posit32_t );
    posit32_t q32_to_p32( quire32_t );

    bint isNaRQ32( quire32_t );
    bint isQ32Zero( quire32_t );
    quire32_t q32_TwosComplement( quire32_t );
    #quire32_t q32_clr( quire32_t );
    quire32_t q32Clr();
    quire32_t castQ32( uint64_t, uint64_t, uint64_t, uint64_t, uint64_t, uint64_t, uint64_t, uint64_t );
    posit32_t castP32( uint32_t );
    posit32_t negP32( posit32_t );

    # Helper
    double convertP32ToDouble( posit32_t );
    # posit32_t convertFloatToP32(float);
    posit32_t convertDoubleToP32( double );
