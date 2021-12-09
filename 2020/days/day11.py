from lib import *

def datafile():
    return "input/11"

class Grid:
  def __init__(self, data, options={}):
    rows = data.splitlines()
    self.options = options
    self.dist = options["dist"]
    self.my = len(rows)
    self.mx = len(rows[0])
    self.grid = {}
    for y in range(0, self.my):
      for x in range(0, self.mx):
        self.grid[(y,x)] = rows[y][x]

  def step(self):
    grid = Grid(self.render(), self.options)
    tolerance = self.options["tolerance"]
    for y in range(0, self.my):
      for x in range(0, self.mx):
        cur = self.grid[(y, x)]
        if cur == "L":
          cnt = self.adjacent(y, x)
          if cnt == 0: # Empty seat with no occupied nearby becomes occupied
            grid.grid[(y, x)] = "#"
        if cur == "#":
          cnt = self.adjacent(y, x)
          if cnt >= tolerance: # Occupied seats near 4+ occupied seats become empty
            grid.grid[(y, x)] = "L"
    return grid

  def count(self, search):
    cnt = 0
    for y in range(0, self.my):
      for x in range(0, self.mx):
        if self.grid[(y, x)] == search:
          cnt += 1
    return cnt

  def render(self):
    screen = []
    for y in range(0, self.my):
      scanline = ""
      for x in range(0, self.mx):
        scanline += self.grid[(y,x)]
      screen.append(scanline)
    return "\n".join(screen)
  
  def adjacent(self, y, x):
    cnt = 0
    for (dy, dx) in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]:
      dist = 1
      while dist <= self.dist:
        cur = self.grid.get((y + dy * dist, x + dx * dist))
        if not cur:
          break
        if cur == "L":
          break
        if cur == "#":
          cnt += 1
          break
        dist += 1
    return cnt


@microbench
def part1(data):
  grid = Grid(data, {"dist": 1, "tolerance": 4})
  last = 0
  while True:
    grid = grid.step()
    count = grid.count("#")
    if count == last:
      print(f"Count: {count}")
      break
    last = count
  # print(grid.render())
  return last
  
@microbench
def part2(data):
  grid = Grid(data, {"dist": 99, "tolerance": 5})
  last = 0
  while True:
    grid = grid.step()
    count = grid.count("#")
    if count == last:
      print(f"Count: {count}")
      break
    last = count
  # print(grid.render())
  return last
