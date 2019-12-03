#!/usr/bin/env python
from functools import lru_cache
@lru_cache(maxsize=4095)
def hamming2(s1, s2):
    """Calculate the Hamming distance between two bit strings"""
    assert len(s1) == len(s2)
    return sum(c1 != c2 for c1, c2 in zip(s1, s2))

@lru_cache(maxsize=4095)
def ld(s, t):
    if not s: return len(t)
    if not t: return len(s)
    if s[0] == t[0]: return ld(s[1:], t[1:])
    l1 = ld(s, t[1:])
    l2 = ld(s[1:], t)
    l3 = ld(s[1:], t[1:])
    return 1 + min(l1, l2, l3)

ids = [line.rstrip('\n') for line in open('2-input.txt')]

md = {}
for id1 in ids:
    min_dist = 9999
    for id2 in ids:
        if id1 is id2:
            continue

        #search_dist = ld(id1, id2)
        search_dist = hamming2(id1, id2)
        if search_dist < min_dist:
            min_dist = search_dist
    print(id1, min_dist)
    if min_dist < 2:
        md[id1] = min_dist

print("Solution is the common letters of the following")
vals = list(md.keys())
print(vals)
diff = set(vals[0]) - set(vals[1])
print(''.join(vals[0].split(sorted(diff)[0])))


