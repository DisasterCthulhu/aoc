#!/usr/bin/env python
import re, operator
from collections import deque

test = 2
if test == 1:
    INPUT = "13-input-test.txt"
elif test == 2:
    INPUT = "13-input-test-2.txt"
else:
    INPUT = "13-input.txt"

class Cart(object):
    NORTH = ( 0, -1)
    EAST =  ( 1,  0)
    SOUTH = ( 0,  1)
    WEST =  (-1,  0)
    NESW = {"^": NORTH,
            ">": EAST,
            "v": SOUTH,
            "<": WEST}
    IMAGE = {NORTH: "^",
             EAST: ">",
             SOUTH: "v",
             WEST: "<"}
    FOLLOW = {(NORTH, '/'): EAST,
            (NORTH, '\\'): WEST,
            (EAST, '/'): NORTH,
            (EAST, '\\'): SOUTH,
            (SOUTH, '/'): WEST,
            (SOUTH, '\\'): EAST,
            (WEST, '/'): SOUTH,
            (WEST, '\\'): NORTH}
    FROM = {NORTH: 0,
            EAST: 1,
            SOUTH: 2,
            WEST: 3}
    TO =  {-1: WEST,
            0: NORTH,
            1: EAST,
            2: SOUTH,
            3: WEST,
            4: NORTH}
    LEFT = -1
    STRAIGHT = 0
    RIGHT = 1

    def __init__(self, x, y, pic):
        self.x = x
        self.y = y
        self.facing = self.NESW[pic]
        self.turns = deque([self.LEFT, self.STRAIGHT, self.RIGHT])

    def image(self):
        return self.IMAGE[self.facing]

    def follow(self, track):
        if track != '+':
            return self.FOLLOW[(self.facing, track)]
        turn = self.turns[0]
        self.turns.rotate(-1)
        return self.TO[self.FROM[self.facing] + turn]

    def tick(self, cave):
        dx, dy = self.facing
        nx = self.x + dx
        ny = self.y + dy
        track = cave[ny][nx]
        # Always move
        self.x = nx
        self.y = ny
        # follow around corners and do a few things at intersections
        if track in ['/', '\\', '+']:
            self.facing = self.follow(track)

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return "<Cart: {}@{}, {}>".format(self.image(), self.x, self.y)

def draw(cave, carts, ticks):
    over = {}
    print("      Ticks: {}".format(ticks))
    for cart in carts:
        if (cart.x, cart.y) in over:
            over[(cart.x, cart.y)] = "X"
        else:
            over[(cart.x, cart.y)] = cart.image()
    for iy, y in enumerate(cave):
        row = []
        for ix, x in enumerate(y):
            if (ix, iy) in over:
                row.append(over[(ix,iy)])
            else:
                row.append(x)
        print("".join(row))

def tick(cave, carts):
    yx = {}
    order = []
    removed = []
    for cart in carts:
        yx[(cart.y, cart.x)] = cart
    for oyx in sorted(yx):
        if oyx not in yx:
            continue
        cart = yx[oyx]
        cart.tick(cave)
        nyx = (cart.y, cart.x)
        del yx[oyx]
        if nyx in yx:
            print("Collision at:", (cart.x, cart.y))
            if len(carts) < 4:
                return False, carts
            for i, check in enumerate(carts):
                if check == cart or check == yx[nyx]:
                    del carts[i]
                    break
            for i, check in enumerate(carts):
                if check == cart or check == yx[nyx]:
                    del carts[i]
                    break
            del yx[nyx]
        else:
            yx[nyx] = cart
    return True, carts

def main():
    cave = []
    carts = []
    for line in open(INPUT):
       y = line.rstrip("\n")
       x = []
       for c in y:
           if c == "<" or c == ">":
               carts.append(Cart(len(x), len(cave), c))
               c = "-"
           if c == "^" or c == "v":
               carts.append(Cart(len(x), len(cave), c))
               c = "|"
           x.append(c)
       cave.append(x)

    for y in cave:
        print("".join(y))
    print(carts)
    ticks = 0
    while True:
        ok, carts = tick(cave, carts)
        ticks += 1
        # draw(cave, carts, ticks)
        if not ok:
            print("Remaining Carts", carts)
            break
    draw(cave, carts, ticks)

if __name__ == "__main__":
    main()
