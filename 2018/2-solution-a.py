#!/usr/bin/env python

ids = [line.rstrip('\n') for line in open('2-input.txt')]

def counts(string):
    vals = {}
    for c in string:
        vals[c] = 1 + vals[c] if c in vals else 1
    return vals

twos = sum([2 in counts(l).values() for l in  ids])
threes = sum([3 in counts(l).values() for l in  ids])
print(twos)
print(threes)
print(twos * threes)
