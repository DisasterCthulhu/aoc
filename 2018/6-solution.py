#!/usr/bin/env python
import re, operator

class Grid(object):
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.coords = {}
        self.setup()

    def setup(self):
        self.grid =  [['.' for i in range(self.y+1)] for j in range(self.x+1)]

    def add_coord(self, coord):
        self.coords[coord.id()] = coord

    def nearest_coord(self, x, y):
        min_dist = max(self.x, self.y) + 1
        multi = False
        tgt = None
#         print("Locating nearest point to", x, y)
        for id in self.coords:
            coord = self.coords[id]
            # if x == coord.x and y == coord.y:
                # continue # you can be your closest coordinate?
            dist = coord.dist(x, y)
            if dist == min_dist:
                multi = True
                tgt = None
            if dist < min_dist:
                # print("Better:", coord.x, coord.y, "old", min_dist, "new", dist)
                tgt = id
                min_dist = dist
                multi = False
        return (tgt, min_dist)

    def process(self):
        for ix, row in enumerate(self.grid):
            for iy, col in enumerate(row):
                res = self.nearest_coord(ix, iy)
                self.grid[ix][iy] = res
                # print (res)
                #print("{}x{}: {}".format(ix, iy, col))

        for id in self.coords:
            self.coords[id].area = 0

        for ix, row in enumerate(self.grid):
            for iy, col in enumerate(row):
                nearest = col[0]
                if nearest == None:
                    continue
                # print(ix, iy, col, nearest)
                # print(nearest)
                self.coords[nearest].area =  self.coords[nearest].area + 1
                if ix == 0 or iy == 0 or ix == self.x or iy == self.y:
                    self.coords[nearest].inf = True

        None

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return "<Grid: {}x{}: Coords: {}>".format(self.x, self.y, len(self.coords))



class Coord(object):
    def __init__(self, line):
        pattern = re.compile(r'(?P<x>\d+), (?P<y>\d+)')
        m = pattern.match(line)
        self.x = int(m.group('x'))
        self.y = int(m.group('y'))
        self.area = 1
        self.nearby = 0
        self.inf = False

    def id(self):
        return (self.x, self.y)

    def dist(self, x, y):
        return abs(self.x - x) + abs(self.y - y)

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        if self.inf:
            return "inf"
        return "<Coord: {}x{}: a{}, n{}>".format(self.x, self.y, self.area, self.nearby)


def main():
    lines = [line.rstrip("\n") for line in open('6-input.txt')]
    coords = {}
    max_x = 0
    max_y = 0
    for line in lines:
        coord = Coord(line)
        coords[coord.id()] = coord
        max_x = max(max_x, coord.x)
        max_y = max(max_y, coord.y)

    grid = Grid(max_x, max_y)
    for coord in coords.values():
        grid.add_coord(coord)

    grid.process()
    largest = 0
    res = None
    for coord in grid.coords.values():
        if coord.inf:
            continue
        if coord.area > largest:
            res = coord
            largest = coord.area
    print(res)
    safe_area = 0
    for ix, row in enumerate(grid.grid):
        for iy, col in enumerate(row):
            min_safe_distance = 0
            for coord in grid.coords.values():
                min_safe_distance = min_safe_distance + coord.dist(ix, iy)
            if min_safe_distance < 10000:
                safe_area = safe_area + 1

    print(safe_area)


if __name__ == "__main__":
    main()
