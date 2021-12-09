from lib import *

class BoardingPass:
  def __init__(self, code):
    self.code = code
    self.row = self.process(code[0:7])
    self.col = self.process(code[-3:])

  def result(self):
    return self.row * 8 + self.col

  def process(self, code):
    return int(
      code.replace("L", "0")
          .replace("F", "0")
          .replace("R", "1")
          .replace("B", "1"),
      2)

def datafile():
    return "input/05"

@microbench
def part1(data):
  boardingpasses = [BoardingPass(code) for code in data.splitlines()]
  high = max([bp.result() for bp in boardingpasses])
  return high

@microbench
def part2(data):
  boardingpasses = [BoardingPass(code).result() for code in data.splitlines()]
  bp = sorted(boardingpasses)
  for code in range(min(bp), max(bp)):
    if code not in bp and code -1 in bp and code + 1 in bp:
      return code
  return None
    
