from lib import *


def datafile():
    return "input/12"


def turn(face, cmd):
    (dir, amt) = (cmd[0], int(cmd[1:]))
    steps = int(amt / 90)
    if dir == "L":
        steps = -steps
    dirs = ["N", "E", "S", "W"]
    l = len(dirs)
    idx = (dirs.index(face) + steps) % l
    if idx < 0:
        idx += l
    return dirs[idx]


dv = {"N": (-1, 0), "E": (0, 1), "S": (1, 0), "W": (0, -1)}


def go(face, cmd):
    (dir, amt) = (cmd[0], int(cmd[1:]))
    if dir == "F":
        dir = face

    (y, x) = dv[dir]
    return (y * amt, x * amt)


@microbench
def part1(data):
    data = data.splitlines()
    pos = (0, 0)
    face = "E"
    for cmd in data:
        if cmd[0] in "LR":
            face = turn(face, cmd)
        if cmd[0] in "NESWF":
            (dy, dx) = go(face, cmd)
            pos = (pos[0] + dy, pos[1] + dx)
    return mdist(pos, (0, 0))


def move_wp(cmd, waypoint):
    (dir, amt) = (cmd[0], int(cmd[1:]))
    (y, x) = dv[dir]
    return (y * amt, x * amt)


def rotate(cmd, ship, waypoint):
    (dir, amt) = (cmd[0], int(cmd[1:]))
    steps = int(amt / 90)
    (dy, dx) = (waypoint[0] - ship[0], waypoint[1] - ship[1])
    if dir == "L":
        while steps > 0:
            (dy, dx) = (-dx, dy)
            steps -= 1
    if dir == "R":
        while steps > 0:
            (dy, dx) = (dx, -dy)
            steps -= 1
    return (dy, dx)


def f(cmd, ship, waypoint):
    amt = int(cmd[1:])
    (dy, dx) = (waypoint[0] - ship[0], waypoint[1] - ship[1])
    return (dy * amt, dx * amt)


@microbench
def part2(data):
    data = data.splitlines()
    waypoint = (-1, 10)
    ship = (0, 0)
    for cmd in data:
        if cmd[0] in "LR":
            (dy, dx) = rotate(cmd, ship, waypoint)
            waypoint = (ship[0] + dy, ship[1] + dx)
        if cmd[0] in "NESW":
            (dy, dx) = move_wp(cmd, waypoint)
            waypoint = (waypoint[0] + dy, waypoint[1] + dx)
        if cmd[0] == "F":
            (dy, dx) = f(cmd, ship, waypoint)
            waypoint = (waypoint[0] + dy, waypoint[1] + dx)
            ship = (ship[0] + dy, ship[1] + dx)
    return mdist(ship, (0, 0))
