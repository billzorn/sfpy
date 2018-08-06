"""Some basic performance tests for the wrapper class"""

import timeit


def ops_sec(stmt, setup):
    # print('----')
    # print(setup)
    print('-- timing: --')
    print(stmt)
    print('----')

    timer = timeit.Timer(stmt, setup)
    iters, time = timer.autorange()

    rate = iters/time
    if rate > 1000000000:
        erate = rate / 1000000000
        unit = 'Gops'
    elif rate > 1000000:
        erate = rate / 1000000
        unit = 'Mops'
    elif rate > 1000:
        erate = rate / 1000
        unit = 'kops'
    else:
        erate = rate
        unit = 'ops'

    print('{} ops, {} s, {} {}/s\n'.format(iters, time, erate, unit))


setup = """import sfpy
import SoftPosit.python.softposit as sp1
import SoftPosit.python._softposit as sp2
zero = 0.0
one = 1.0
sfpy_a = sfpy.Posit16(1.3)
sfpy_b = sfpy.Posit16(-0.5)
sfpy_c = sfpy.Posit16(15.0)
sfpy_q = sfpy.Quire16(0)

sp1_a = sp1.posit16(1.3)
sp1_b = sp1.posit16(-0.5)
sp1_c = sp1.posit16(15.0)
sp1_q = sp1.quire16()
"""
"""
sp2_a = sp2.convertDoubleToP16(1.3)
sp2_b = sp2.convertDoubleToP16(-0.5)
sp2_c = sp2.convertDoubleToP16(15.0)
sp2_q = sp2.new_quire16_t()
"""

ops_sec('pass', setup)
ops_sec('sfpy.Posit16(0)', setup)
ops_sec('sp1.posit16(0)', setup)
#ops_sec('sp2.new_posit16_t()', setup)

ops_sec('one + zero', setup)
ops_sec('sfpy_a + sfpy_b', setup)
ops_sec('sp1_a + sp1_b', setup)
#ops_sec('sp2_a + sp2_b', setup)

ops_sec('sfpy_c += sfpy_b', setup)

# ops_sec('P8(0)', setup)
# ops_sec('P8("0")', setup)
# ops_sec('P8.from_bits(0)', setup)

# ops_sec('1.1 + 2', setup)
# ops_sec('a + b', setup)
# ops_sec('a.add(b)', setup)
# ops_sec('zero += 1', setup)
# ops_sec('a += b', setup)
# ops_sec('a.iadd(b)', setup)

# ops_sec('q.fdp_add(b, c)', setup)
