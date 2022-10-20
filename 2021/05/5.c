inherit "/w/elronuan/aoc/2021/helper";

int part1(mixed array vents, status diag) {
  mixed grid = allocate( ({1000, 1000}), ".");
  foreach(int array line in vents) {
    int x1 = line[0];
    int y1 = line[1];
    int x2 = line[2];
    int y2 = line[3];
    int dx = sgn(x2-x1);
    int dy = sgn(y2-y1);
    if(!diag && dx && dy)
      continue;
    if(diag && (dx && dy) && (abs(x2-x1) != abs(y2-y1) ))
      continue;
    int x = x1;
    int y = y1;
    status cont = False;
    do {
      if(grid[y][x] == ".") {
        grid[y][x] = 0;
      }
      grid[y][x] += 1;
      cont = x!=x2 || y != y2;
      x+=dx;
      y+=dy;
    } while(cont);
    //dbg_grid(grid);
  }
  return reduce(grid, (:
      return $1 + count($2, (: return to_int($1) > 1; :));
    :));
}

mixed array parse(string array lines) {
  return map(lines, (:
    return to_ints(explode(implode(explode($1, " -> "), ","), ","));
  :));
}

void configure() {
  ::configure();
  set_day(5);
  mixed array samples = parse(to_lines(input("sample")));
  mixed array values = parse(to_lines(input(1)));
  dbg(part1(samples, False));
  dbg(part1(values, False));
  dbg(part1(samples, True));
  dbg(part1(values, True));
}
