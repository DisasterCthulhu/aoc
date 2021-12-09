from lib import *

def datafile():
  return "input/01"

def parse(data):
  return ints(data)

@microbench
def part1(data):
  data = parse(data)
  for i in data:
    if 2020-i in data:
      return i * (2020-i)

@microbench
def part2(data):
  data = parse(data)
  for i in data:
    smol = [x for x in data if x < i and i + x < 2020]
    for s in smol:
      if 2020 - s - i in data:
        return i * s * (2020 - s - i)