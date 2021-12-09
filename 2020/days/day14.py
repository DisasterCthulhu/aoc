from lib import *
from itertools import permutations, combinations, product

def datafile():
    return "input/14"

def process_mask(mask):
  bitand = pow(2, 36)-1
  bitor = 0
  for i, c in enumerate(mask[::-1]):
    if c == "X":
      continue
    if c == "1":
      bitor += pow(2, i)
    if c == "0":
      bitand -= pow(2, i)

  return (bitand, bitor)

@microbench
def part1(data):
  mem = defaultdict(int)
  mask = 0
  bitand = pow(2, 36) -1
  bitor = 0
  for line in data.splitlines():
    
    if "mem" in line:
      m = re.match("mem\[(\d+)\] = (\d+)", line)
      (addr, val) = m.groups()
      mem[addr] = (int(val) | bitor) & bitand
    else:
      m = re.match("mask = ([01X]+)", line)
      (mask,)  = m.groups()
      (bitand, bitor) = process_mask(mask)
  return sum(mem.values())


def faddrs(addr, mask):
  addrs = [i for i, c in enumerate(mask) if c == "X"]
  for bits in product([0, 1], repeat=len(addrs)):
    m = 0
    

  return (addrs, )

@microbench
def part2(data):
  mem = defaultdict(int)
  mask = 0
  bitand = pow(2, 36) -1
  addror = 0
  for line in data.splitlines():
    
    if "mem" in line:
      m = re.match("mem\[(\d+)\] = (\d+)", line)
      (addr, val) = m.groups()
      for faddr in faddrs(addr, mask):
        mem[faddr] = int(val)
    else:
      m = re.match("mask = ([01X]+)", line)
      (mask,)  = m.groups()
  
  return sum(mem.values())