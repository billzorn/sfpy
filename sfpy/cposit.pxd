from libc.stdint cimport *

cdef extern from '../SoftPosit/source/include/softposit.h':

    ctypedef struct posit8_t:
        pass

    ctypedef struct posit16_t:
        pass

    ctypedef struct posit32_t:
        pass

    ctypedef struct posit64_t:
        pass

    ctypedef struct posit128_t:
        pass

    ctypedef struct quire8_t:
        pass

    ctypedef struct quire16_t:
        pass

    ctypedef struct quire32_t:
        pass

    # /*----------------------------------------------------------------------------
    # | Integer-to-posit conversion routines.
    # *----------------------------------------------------------------------------*/

    posit8_t  ui32_to_p8( uint32_t );
    posit16_t ui32_to_p16( uint32_t );
    posit32_t ui32_to_p32( uint32_t );
    posit64_t ui32_to_p64( uint32_t );

    posit8_t  ui64_to_p8( uint64_t );
    posit16_t ui64_to_p16( uint64_t );
    posit32_t ui64_to_p32( uint64_t );
    posit64_t ui64_to_p64( uint64_t );

    posit8_t  i32_to_p8( int32_t );
    posit16_t i32_to_p16( int32_t );
    posit32_t i32_to_p32( int32_t );
    posit64_t i32_to_p64( int32_t );

    posit8_t  i64_to_p8( int64_t );
    posit16_t i64_to_p16( int64_t );
    posit32_t i64_to_p32( int64_t );
    posit64_t i64_to_p64( int64_t );

    # /*----------------------------------------------------------------------------
    # | 8-bit (quad-precision) posit operations.
    # *----------------------------------------------------------------------------*/

    bint isNaRP8UI( uint8_t );

    uint_fast32_t p8_to_ui32( posit8_t );
    uint_fast64_t p8_to_ui64( posit8_t );
    int_fast32_t p8_to_i32( posit8_t );
    int_fast64_t p8_to_i64( posit8_t );

    posit16_t p8_to_p16( posit8_t );
    #posit32_t p8_to_p32( posit8_t );
    #posit64_t p8_to_p64( posit8_t );

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
    quire8_t q8_clr( quire8_t );
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
    #posit32_t p16_to_p32( posit16_t );
    #posit64_t p16_to_p64( posit16_t );

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

    #Quire 16
    quire16_t q16_fdp_add( quire16_t, posit16_t, posit16_t );
    quire16_t q16_fdp_sub( quire16_t, posit16_t, posit16_t );
    #posit16_t convertQ16ToP16( quire16_t );
    posit16_t q16_to_p16( quire16_t );

    bint isNaRQ16( quire16_t );
    bint isQ16Zero( quire16_t );
    #quire16_t q16_TwosComplement( quire16_t );

    #void printBinary( uint64_t*, int );
    #void printHex( uint64_t );

    quire16_t q16_clr( quire16_t );
    quire16_t castQ16( uint16_t, uint16_t );
    posit16_t castP16( uint16_t );
    uint16_t castUI16( posit16_t );
    posit16_t negP16( posit16_t );

    # Helper
    double convertP16ToDouble( posit16_t );
    #posit16_t convertFloatToP16( float );
    posit16_t convertDoubleToP16( double );