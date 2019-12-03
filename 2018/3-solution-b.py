#!/usr/bin/env python
import re

class Grid(object):
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.grid =  [[0 for i in range(x)] for j in range(y)]


    def add_claim(self, claim):
        for i in range(claim.width):
            for j in range(claim.height):
                self.grid[claim.x+i][claim.y+j] = self.grid[claim.x+i][claim.y+j] + 1

    def overlaps(self, claim):
        overlap = False
        for i in range(claim.width):
            for j in range(claim.height):
                if self.grid[claim.x+i][claim.y+j] > 1:
                    overlap = True
        return overlap

class Claim(object):
    #1 @ 53,238: 26x24

    def __init__(self, line):
        pattern = re.compile(r'#(?P<id>\d+) @ (?P<x>[^,]+),(?P<y>[^:]+): (?P<width>[^x]+)x(?P<height>\d+)')
        m = pattern.match(line)
        self.id = m.group('id')
        self.x = int(m.group('x'))
        self.y = int(m.group('y'))
        self.width = int(m.group('width'))
        self.height = int(m.group('height'))

    def __str__(self):
        return "<Claim: #{} @ {},{}: {}x{}>".format(self.id, self.x, self.y, self.width, self.height)

claims = {}
for line in open('3-input.txt'):
    claim = Claim(line.rstrip("\n"))
    claims[claim.id] = claim

grid = Grid(1000, 1000)
for claim in claims.values():
    # print(claim)
    grid.add_claim(claim)


overlap = 0
for i in range(grid.x):
    for j in range(grid.y):
        if grid.grid[i][j] > 1:
            overlap = overlap + 1
print("Overlap: ", overlap)

for claim in claims.values():
    if grid.overlaps(claim) == False:
        print("No Overlap: ", claim)
