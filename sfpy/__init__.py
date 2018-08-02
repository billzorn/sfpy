import os
mypath = os.path.abspath(os.path.dirname(__file__))

print('hi from module sfpy @ {:s}'.format(mypath))

from .posit import Posit8, Quire8, Posit16, Quire16

from .float import Float16, Float32, Float64
