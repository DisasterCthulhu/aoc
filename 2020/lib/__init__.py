from .microbench import microbench
from .crud import cat, ints, slurp
from .containment import intersection
import re as re
from collections import defaultdict


def mdist(lhs, rhs):
    (y1, x1) = lhs
    (y2, x2) = rhs
    dy = abs(y1 - y2)
    dx = abs(x1 - x2)
    return dy + dx
