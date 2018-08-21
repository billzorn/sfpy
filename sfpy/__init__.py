from . import posit as softposit
from . import float as softfloat
from .posit import Posit8, Quire8, Posit16, Quire16, Posit32, Quire32
from .float import Float16, Float32, Float64

__all__ = [
    'softfloat',
    'softposit',
    'Posit8', 'Quire8',
    'Posit16', 'Quire16',
    'Posit32', 'Quire32',
    'Float16',
    'Float32',
    'Float64',
]
