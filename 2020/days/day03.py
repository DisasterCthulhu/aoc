from lib import *

def datafile():
    return "input/03"

def check_slope(data, dy, dx):
    hits = 0
    y = x = 0
    lines = data.splitlines()
    w = len(lines[0])
    end = len(lines)
    while True:
        (y, x) = (y + dy, x + dx)
        if y >= end:
            return hits
        if lines[y][x % w] == "#":
            hits += 1
    return hits

@microbench
def part1(data):
    dy = 1
    dx = 3
    return check_slope(data, dy, dx)

@microbench
def part2(data):
    slopes = [(1, 1), (1, 3), (1, 5), (1, 7), (2, 1)]
    trees = 1
    for (dy, dx) in slopes:
        trees *= check_slope(data, dy, dx)
    return trees
