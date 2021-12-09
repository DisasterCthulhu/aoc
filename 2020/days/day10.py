from lib import *

def datafile():
    return "input/10"

@microbench
def part1(data):
  adapters = ints(data)
  diffs = {1: 0, 2: 0, 3: 0}
  last = 0
  while True:
    found = False
    for jump in range(1,4):
      if last + jump in adapters:
        diffs[jump] += 1
        last += jump
        found = True
        break
    if not found:
      break
  print(diffs)
  return diffs[1] * (diffs[3]+1)




@microbench
def part2(data):
  adapters = [0] + ints(data)
  adapters.append(max(adapters) + 3)
  adapters.sort()
  end = len(adapters) - 1

  memo = {}
  def dp(idx):
    if idx == end - 1:
      return 1
    if idx in memo:
      return memo[idx]
    cnt = 0
    for j in range(idx + 1, end):
      if adapters[j] - adapters[idx] <= 3:
        cnt += dp(j)
    memo[idx] = cnt
    return cnt

  # 3454189699072
  return dp(0)
