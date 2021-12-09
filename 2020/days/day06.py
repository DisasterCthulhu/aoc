from lib import *


def datafile():
    return "input/06"


def slurp(data):
    return data.split("\n\n")


def parse(data):
    return


@microbench
def part1(data):
    data = [set("".join(group.split())) for group in slurp(data)]
    cnt = 0
    for group in data:
        cnt += len(group)
    return cnt


@microbench
def part2(data):
    cnt = 0
    for group in [group for group in slurp(data)]:
        answers = [set(a) for a in group.splitlines()]
        cnt += len(intersection(*answers))
    return cnt
