#!/usr/bin/env python
import re, operator

def char_range(c1, c2):
    """Generates the characters from `c1` to `c2`, inclusive."""
    for c in range(ord(c1), ord(c2)+1):
        yield chr(c)

def capitalize(c):
    return chr(ord(c)-32)

def reduce(polymer):
    while True:
        found = False
        for c in char_range("a", "z"):
            r1 = c + capitalize(c)
            r2 = capitalize(c) + c
            if r1 in polymer or r2 in polymer:
                found = True
                polymer = polymer.replace(r1, "").replace(r2, "")
        if found == False:
            break
    return polymer

line = open('5-input.txt').read().rstrip("\n")
print("Initial len:", len(line))
reduced_polymer = reduce(line)
print("Reduced Length", len(reduced_polymer))

culled = {}
for c in char_range("a", "z"):
    culled[c] = len(reduce(reduced_polymer.replace(c, "").replace(capitalize(c), "")))
best = min(culled.items(), key=operator.itemgetter(1))
print("Best polymer to cull:", best)


