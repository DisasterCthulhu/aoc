#!/usr/bin/env python

changes = [line.rstrip('\n') for line in open('1-input.txt')]
frequencies = {}
index = 0
last_freq = 0
while last_freq not in frequencies:
    frequencies[last_freq] = True
    last_freq += int(changes[index])
    index = (index+1) % len(changes)

print(last_freq)

