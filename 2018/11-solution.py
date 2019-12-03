#!/usr/bin/env python
import re, operator
from collections import deque

test = False
if test:
    INPUT = "11-input-test.txt"
else:
    INPUT = "11-input.txt"

class Grid(object):
    def __init__(self, serial):
        self.serial = int(serial)
        grid = {}
        for x in range(1, 301):
            grid[x] = {}
            for y in range(1,301):
                grid[x][y] = self.pow(x, y)
        self.grid = grid
        self.red = {}

    def nearby(self, x, y, z):
        val = 0
        for i in range(x, x+z):
            for j in range(y, y+z):
                val += self.grid[i][j]
        return val

    def reduce(self):
        high = 0
        loc = (0,0)
        for x in range(1, 301-2):
            for y in range(1,301-2):
                val = self.nearby(x, y, 3)
                if val > high:
                    high = val
                    loc = (x, y)

        print("3x3: Reduced High:", high, loc)
        high = 0
        loc = (0,0,0)
        for z in range(1, 15): #301
            for x in range(1, 301-2):
                if x + z > 300:
                    continue
                for y in range(1,301-2):
                    if y + z > 300:
                        continue
                    val = self.nearby(x, y, z)
                    if val > high:
                        high = val
                        loc = (x, y, z)
                        print("Any% New: Reduced High:", high, loc)
        print("Any% Final: Reduced High:", high, loc)


    def pow(self, x, y):
        return ((x+10) * y + self.serial) * (x+10)/100%10 -5

    def draw(self):
        s = ""
        high = 0
        for y in range(1, 301):
            for x in range(1, 301):
                if x in self.grid and y in self.grid[x]:
                    v = self.grid[x][y]
                    if v > high:
                        high = v
                    s += str(v)
                else:
                    s += "."
            s += "\n"
        print(s)
        print("high", high)


    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return "<Grid: {}x{}: Coords: {}>".format(self.x, self.y, len(self.coords))



class Point(object):
    def __init__(self, line):
        #position=< 9,  1> velocity=< 0,  2>
        print(line)
        pattern = re.compile(r'position=<(?P<ix>[- ]*\d+),(?P<iy>[- ]*\d+)> velocity=<(?P<vx>[- ]*\d+),(?P<vy>[- ]*\d+)>')
        m = pattern.match(line)
        self.id = line
        self.x = int(m.group('ix'))
        self.y = int(m.group('iy'))
        self.vx = int(m.group('vx'))
        self.vy = int(m.group('vy'))

    def id(self):
        return (self.x, self.y)

    def dist(self, x, y):
        return abs(self.x - x) + abs(self.y - y)

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        if self.inf:
            return "inf"
        return "<Coord: {}x{}>".format(self.x, self.y)


def main():
    grid = Grid(6548)
    #grid.draw()
    grid.reduce()
    # points = [Point(line.rstrip("\n")) for line in open(INPUT)]

if __name__ == "__main__":
    main()
