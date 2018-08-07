import sfpy


print('testing Poist8 neg / abs...')
for i in range(1 << 8):
    x = sfpy.Posit8(i)
    neg_x = -x
    minus_x = x * sfpy.Posit8(-1.0)

    if not neg_x.bits == minus_x.bits:
        print('-', x, neg_x, minus_x)

    neg_x2 = sfpy.posit.p8_neg(x)

    if not neg_x2.bits == minus_x.bits:
        print('p8_neg', x, neg_x2, minus_x)

    x.ineg()

    if not x.bits == minus_x.bits:
        print('ineg', x, minus_x)


    y = sfpy.Posit8(i)
    abs_y = abs(y)
    if y < sfpy.Posit8(0):
        ifneg_y = y * sfpy.Posit8(-1.0)
    else:
        ifneg_y = y * sfpy.Posit8(1.0)

    if not abs_y.bits == ifneg_y.bits:
        print('abs', y, abs_y, ifneg_y)

    abs_y2 = sfpy.posit.p8_abs(y)

    if not abs_y2.bits == ifneg_y.bits:
        print('p8_abs', y, abs_y2, ifneg_y)

    y.iabs()

    if not y.bits == ifneg_y.bits:
        print('iabs', y, ifneg_y)


print('testing Poist16 neg / abs...')
for i in range(1 << 16):
    x = sfpy.Posit16(i)
    neg_x = -x
    minus_x = x * sfpy.Posit16(-1.0)

    if not neg_x.bits == minus_x.bits:
        print('-', x, neg_x, minus_x)

    neg_x2 = sfpy.posit.p16_neg(x)

    if not neg_x2.bits == minus_x.bits:
        print('p16_neg', x, neg_x2, minus_x)

    x.ineg()

    if not x.bits == minus_x.bits:
        print('ineg', x, minus_x)


    y = sfpy.Posit16(i)
    abs_y = abs(y)
    if y < sfpy.Posit16(0):
        ifneg_y = y * sfpy.Posit16(-1.0)
    else:
        ifneg_y = y * sfpy.Posit16(1.0)

    if not abs_y.bits == ifneg_y.bits:
        print('abs', y, abs_y, ifneg_y)

    abs_y2 = sfpy.posit.p16_abs(y)

    if not abs_y2.bits == ifneg_y.bits:
        print('p16_abs', y, abs_y2, ifneg_y)

    y.iabs()

    if not y.bits == ifneg_y.bits:
        print('iabs', y, ifneg_y)


print('testing Poist32 neg / abs...')
for i in range(1 << 32):
    x = sfpy.Posit32(i)
    neg_x = -x
    minus_x = x * sfpy.Posit32(-1.0)

    if not neg_x.bits == minus_x.bits:
        print('-', x, neg_x, minus_x)

    neg_x2 = sfpy.posit.p32_neg(x)

    if not neg_x2.bits == minus_x.bits:
        print('p32_neg', x, neg_x2, minus_x)

    x.ineg()

    if not x.bits == minus_x.bits:
        print('ineg', x, minus_x)


    y = sfpy.Posit32(i)
    abs_y = abs(y)
    if y < sfpy.Posit32(0):
        ifneg_y = y * sfpy.Posit32(-1.0)
    else:
        ifneg_y = y * sfpy.Posit32(1.0)

    if not abs_y.bits == ifneg_y.bits:
        print('abs', y, abs_y, ifneg_y)

    abs_y2 = sfpy.posit.p32_abs(y)

    if not abs_y2.bits == ifneg_y.bits:
        print('p32_abs', y, abs_y2, ifneg_y)

    y.iabs()

    if not y.bits == ifneg_y.bits:
        print('iabs', y, ifneg_y)


print('...done.')
