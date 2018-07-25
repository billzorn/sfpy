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
P8 = sfpy.Posit8
Q8 = sfpy.Quire8
a = P8(1.3)
b = P8(-0.5)
c = P8(15.0)
q = Q8()
zero = 0.0
"""

ops_sec('pass', setup)
ops_sec('P8(0)', setup)
ops_sec('P8("0")', setup)
ops_sec('P8.from_bits(0)', setup)

ops_sec('1.1 + 2', setup)
ops_sec('a + b', setup)
ops_sec('a.add(b)', setup)
ops_sec('zero += 1', setup)
ops_sec('a += b', setup)
ops_sec('a.iadd(b)', setup)

ops_sec('q.fdp_add(b, c)', setup)
