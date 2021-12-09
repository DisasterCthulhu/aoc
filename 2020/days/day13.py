from lib import *
from sympy.ntheory.modular import crt


def datafile():
    return "input/13"


def next_time(est, num):
    if est % num == 0:
        return est
    next = ((est + num) // num) * num
    return next


@microbench
def part1(data):
    (est, ids) = data.splitlines()
    est = int(est)
    # TODO: make this more egronomic

    ids = ints("\n".join(ids.replace("x,", "").split(",")))
    min_time = 99999999
    res = None
    for num in ids:
        next = next_time(est, num)
        if next < min_time:
            min_time = next
            res = (num, next)

    (num, next) = res
    res = (next - est) * num
    return res


def check_schedule(ts, nums):
    for idx, num in enumerate(nums):
        if not num:
            continue
        if (ts + idx) % num != 0:
            return False
    return True


@microbench
def part2(data):
    (est, ids) = data.splitlines()
    est = int(est)
    nums = [(int(x), -i) for i, x in enumerate(ids.split(",")) if x != "x"]
    print(nums)
    ids, times = zip(*nums)
    # chinese remainder theorem
    return crt(ids, times)[0]
