import multiprocessing
import time
import itertools
import re
import math
import random

import numpy

import sfpy
import softfloat
import softposit


posit_derepr = re.compile(r'Posit[0-9]+\((.*)\)')

def posit_get_classes(nbits):
    if nbits == 8:
        return sfpy.Posit8, softposit.posit8
    elif nbits == 16:
        return sfpy.Posit16, softposit.posit16
    elif nbits == 32:
        return sfpy.Posit32, softposit.posit32
    else:
        raise ValueError('no representation of {}-bit posits'.format(repr(nbits)))

def posit_get_fn(mod, nbits, fn):
    return getattr(mod, 'p' + str(nbits) + '_' + fn)

def posit_get_rounding_arguments(nbits, extra=False):
    sfpy_cls, sp_cls = posit_get_classes(nbits)
    mask = (1 << nbits) - 1
    inf = float('inf')
    ninf = float('-inf')

    cases = set()
    for i in range(1 - (1<<(nbits-1)), (1<<(nbits-1)) - 1):
        f1 = float(sfpy_cls(i & mask))
        f2 = float(sfpy_cls((i+1) & mask))
        mean = (f1 + f2) / 2
        geomean = math.sqrt(f1 * f2)

        cases.add(f1)
        cases.add(float(numpy.nextafter(f1, ninf)))
        cases.add(float(numpy.nextafter(f1, inf)))
        cases.add(mean)
        cases.add(float(numpy.nextafter(mean, ninf)))
        cases.add(float(numpy.nextafter(mean, inf)))
        cases.add(geomean)
        cases.add(float(numpy.nextafter(geomean, ninf)))
        cases.add(float(numpy.nextafter(geomean, inf)))

    cases.add(f2)
    cases.add(float(numpy.nextafter(f2, ninf)))
    cases.add(float(numpy.nextafter(f2, inf)))

    if extra:
        morecases = set()
        for case in cases:
            if case != 0:
                morecases.add(1 / case)
            morecases.add(-case)

        cases.update(morecases)

    return sorted(cases)


def posit_test_representation_bits(nbits, it):
    sfpy_cls, sp_cls = posit_get_classes(nbits)
    for i in it:
        sfpy_1 = sfpy_cls(i)
        sfpy_2 = sfpy_cls.from_bits(i)
        sp_1 = sp_cls(0)
        sp_1.fromBits(i)

        if not (
                sfpy_1.bits == sfpy_2.bits == sp_1.v.v
            and float(sfpy_1) == float(sfpy_2) == float(sp_1)
            # problem: nan
            # and int(sfpy_1) == int(sfpy_2) == int(sp_1)
        ):
            print('representation mismatch on bits: {}'.format(repr(i)))
            return True

        sfpy_3 = sfpy_cls(float(str(sfpy_1)))
        sfpy_4 = sfpy_cls(float(str(sfpy_2)))
        sfpy_5 = sfpy_cls(float(posit_derepr.match(repr(sfpy_1)).group(1)))
        sfpy_6 = sfpy_cls(float(posit_derepr.match(repr(sfpy_2)).group(1)))
        # problem: 'NaR' strings
        # sp_2 = sp_cls(float(str(sp_1)))
        # sp_3 = sp_cls(float(repr(sp_1)))

        if not (
                sfpy_1.bits == sfpy_3.bits == sfpy_4.bits == sfpy_5.bits == sfpy_6.bits # == sp_2.v.v == sp_3.v.v
        ):
            print('string representation mismatch on bits: {}'.format(repr(i)))
            return True

    return False

def posit_test_representation_floats(nbits, it):
    sfpy_cls, sp_cls = posit_get_classes(nbits)
    for f in it:
        sfpy_1 = sfpy_cls(f)
        sfpy_2 = sfpy_cls.from_double(f)
        sp_1 = sp_cls(f)

    if not (
                sfpy_1.bits == sfpy_2.bits == sp_1.v.v
        ):
            print('bit representation mismatch on float: {}'.format(repr(i)))
            return True

    return False


def posit_test_neg(nbits, it):
    fname = 'neg'
    sfpy_cls, sp_cls = posit_get_classes(nbits)
    fn = posit_get_fn(sfpy.posit, nbits, fname)
    for i in it:
        sfpy_0 = sfpy_cls(i)
        sfpy_1 = -sfpy_0
        sfpy_2 = sfpy_0.neg()
        sfpy_3 = sfpy_cls(i)
        sfpy_3.ineg()
        sfpy_4 = fn(sfpy_0)

        sp_0 = sp_cls(0)
        sp_0.fromBits(i)
        sp_1 = -sp_0

        if not (
                sp_1.v.v == sfpy_1.bits == sfpy_2.bits == sfpy_3.bits == sfpy_4.bits
        ):
            print('{} mismatch on bits: {}'.format(fname, repr(i)))
            return True

    return False


def dispatch_test(pool, workers, n, test, nbits, *it):
    print('running {}'.format(repr(test)))
    if not it:
        return False

    idx = 0
    work_slots = []

    for i in range(workers):
        new_idx = idx + n
        it0 = it[0][idx:new_idx]
        if it0:
            print('  dispatch {:d}:{:d}'.format(idx, new_idx))
            work_slots.append(pool.apply_async(test, (nbits, it0, *(it[1:]))))
        idx = new_idx

    # crude sleep-wait loop to redispatch
    working = True
    while working:
        for i, result in enumerate(work_slots):
            if result.ready():
                failed = result.get()
                if failed:
                    return True
                else:
                    new_idx = idx + n
                    it0 = it[0][idx:new_idx]
                    if it0:
                        print('  dispatch {:d}:{:d}'.format(idx, new_idx))
                        work_slots[i] = pool.apply_async(test, (nbits, it0, *(it[1:])))
                    else:
                        working = False
                        break
                    idx = new_idx
        time.sleep(0.1)

    for result in work_slots:
        result.wait()
        failed = result.get()
        if failed:
            return True

    return False


if __name__ == '__main__':
    import os
    workers = os.cpu_count()

    pool = multiprocessing.Pool(processes=workers, maxtasksperchild=1)

    failed = (
        dispatch_test(pool, workers, 256, posit_test_representation_bits, 8, range(1 << 8))
        or dispatch_test(pool, workers, 10000, posit_test_representation_bits, 16, range(1 << 16))
    )

    args = posit_get_rounding_arguments(8, True)
    dispatch_test(pool, workers, 10000, posit_test_representation_floats, 8, args)
    args = posit_get_rounding_arguments(16, True)
    dispatch_test(pool, workers, 100000, posit_test_representation_floats, 16, args)

    failed = failed or (
        dispatch_test(pool, workers, 256, posit_test_neg, 8, range(1 << 8))
        or dispatch_test(pool, workers, 10000, posit_test_neg, 16, range(1 << 16))
    )
    
    
    
    print('Failed?', failed)

    # print('testing Poist8 neg / abs...')
    # for i in range(1 << 8):
    #     x = sfpy.Posit8(i)
    #     neg_x = -x
    #     minus_x = x * sfpy.Posit8(-1.0)

    #     if not neg_x.bits == minus_x.bits:
    #         print('-', x, neg_x, minus_x)

    #     neg_x2 = sfpy.posit.p8_neg(x)

    #     if not neg_x2.bits == minus_x.bits:
    #         print('p8_neg', x, neg_x2, minus_x)

    #     x.ineg()

    #     if not x.bits == minus_x.bits:
    #         print('ineg', x, minus_x)


    #     y = sfpy.Posit8(i)
    #     abs_y = abs(y)
    #     if y < sfpy.Posit8(0):
    #         ifneg_y = y * sfpy.Posit8(-1.0)
    #     else:
    #         ifneg_y = y * sfpy.Posit8(1.0)

    #     if not abs_y.bits == ifneg_y.bits:
    #         print('abs', y, abs_y, ifneg_y)

    #     abs_y2 = sfpy.posit.p8_abs(y)

    #     if not abs_y2.bits == ifneg_y.bits:
    #         print('p8_abs', y, abs_y2, ifneg_y)

    #     y.iabs()

    #     if not y.bits == ifneg_y.bits:
    #         print('iabs', y, ifneg_y)


    # print('testing Poist16 neg / abs...')
    # for i in range(1 << 16):
    #     x = sfpy.Posit16(i)
    #     neg_x = -x
    #     minus_x = x * sfpy.Posit16(-1.0)

    #     if not neg_x.bits == minus_x.bits:
    #         print('-', x, neg_x, minus_x)

    #     neg_x2 = sfpy.posit.p16_neg(x)

    #     if not neg_x2.bits == minus_x.bits:
    #         print('p16_neg', x, neg_x2, minus_x)

    #     x.ineg()

    #     if not x.bits == minus_x.bits:
    #         print('ineg', x, minus_x)


    #     y = sfpy.Posit16(i)
    #     abs_y = abs(y)
    #     if y < sfpy.Posit16(0):
    #         ifneg_y = y * sfpy.Posit16(-1.0)
    #     else:
    #         ifneg_y = y * sfpy.Posit16(1.0)

    #     if not abs_y.bits == ifneg_y.bits:
    #         print('abs', y, abs_y, ifneg_y)

    #     abs_y2 = sfpy.posit.p16_abs(y)

    #     if not abs_y2.bits == ifneg_y.bits:
    #         print('p16_abs', y, abs_y2, ifneg_y)

    #     y.iabs()

    #     if not y.bits == ifneg_y.bits:
    #         print('iabs', y, ifneg_y)


    # print('testing Poist32 neg / abs...')
    # for i in range(1 << 32):
    #     x = sfpy.Posit32(i)
    #     neg_x = -x
    #     minus_x = x * sfpy.Posit32(-1.0)

    #     if not neg_x.bits == minus_x.bits:
    #         print('-', x, neg_x, minus_x)

    #     neg_x2 = sfpy.posit.p32_neg(x)

    #     if not neg_x2.bits == minus_x.bits:
    #         print('p32_neg', x, neg_x2, minus_x)

    #     x.ineg()

    #     if not x.bits == minus_x.bits:
    #         print('ineg', x, minus_x)


    #     y = sfpy.Posit32(i)
    #     abs_y = abs(y)
    #     if y < sfpy.Posit32(0):
    #         ifneg_y = y * sfpy.Posit32(-1.0)
    #     else:
    #         ifneg_y = y * sfpy.Posit32(1.0)

    #     if not abs_y.bits == ifneg_y.bits:
    #         print('abs', y, abs_y, ifneg_y)

    #     abs_y2 = sfpy.posit.p32_abs(y)

    #     if not abs_y2.bits == ifneg_y.bits:
    #         print('p32_abs', y, abs_y2, ifneg_y)

    #     y.iabs()

    #     if not y.bits == ifneg_y.bits:
    #         print('iabs', y, ifneg_y)


    # print('...done.')
