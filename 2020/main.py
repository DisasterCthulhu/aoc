from lib import cat
from days.day13 import *

# day08: asm interperter
# day10: tribonacci refactor, also check earlier attempts after fixing input munge
# day11: grids, shuold check against 2018 versions. 

def main():
  data = cat(datafile())
  

  print(f"Part1: {part1(data)}")
  print(f"Part2: {part2(data)}")
  # part2(cat(datafile()))

if __name__ == "__main__":
  main()