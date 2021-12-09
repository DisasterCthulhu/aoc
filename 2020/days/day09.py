from lib import *


def datafile():
    return "input/09"


@microbench
def part1(data):
    offset = 25  # 5 for sample data
    data = ints(data)
    recent = data[0:offset]
    for num in data[offset:]:
        found = None
        for n in recent:
            if (num - n) in recent:
                found = n
        if not found:
            return num
        recent.pop(0)
        recent.append(num)
    return recent


def find_seq_sum(data, target):
    start = 0
    end = 1
    s = sum(data[start : end + 1])  # non-inclusive, partial sum rest
    while True:
        if s < target:
            end += 1
            s += data[end]
        elif s > target:
            s -= data[start]
            start += 1
        elif s == target:
            return min(data[start : end + 1]) + max(data[start : end + 1])


@microbench
def part2(data):
    invalid = 22406676  # part1(data)
    data = ints(data)
    return find_seq_sum(data, invalid)

    return None
