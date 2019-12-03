#!/usr/bin/env python
import re, operator
from collections import deque

test = False
if test:
    INPUT = "10-input-test.txt"
else:
    INPUT = "10-input.txt"

class Sky(object):
    def __init__(self):
        self.points = []

    def add_point(self, point):
        self.points.append(point)

    # x: -1, 0 1
    # y: -1
    # y:  0
    # y:  1
    def step(self, amt=1):
        for point in self.points:
            point.x += point.vx * amt
            point.y += point.vy * amt

    def size(self):
        hx = -9999
        lx = 9999
        hy = -9999
        ly = 9999
        for p in self.points:
            if p.x > hx:
                hx = p.x
            if p.x < lx:
                lx = p.x
            if p.y > hy:
                hy = p.y
            if p.y < ly:
                ly = p.y
        return ((lx, hx), (ly, hy))

    def draw(self):
        dim = self.size()
        grid = {}
        for p in self.points:
            if p.x not in grid:
                grid[p.x] = {}
            if p.y not in grid[p.x]:
                grid[p.x][p.y] = True
        s = ""
        for y in range(dim[1][0], dim[1][1]+1):
            for x in range(dim[0][0], dim[0][1]+1):
                if x in grid and y in grid[x]:
                    s += "X"
                else:
                    s += "."
            s += "\n"
        print(s)



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
    sky = Sky()
    points = [Point(line.rstrip("\n")) for line in open(INPUT)]
    for point in points:
        sky.add_point(point)
    steps = 0
    while True:
        dim = sky.size()
        sy = dim[1][1] - dim[1][0]
        if sy < 16:
            print(dim)
            sky.draw()
            print(steps)
            break
        sky.step()
        steps += 1

if __name__ == "__main__":
    main()
