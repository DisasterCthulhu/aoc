inherit "/w/elronuan/aoc/2021/helper";

string to_key(int array env) {
  return to_string(env[0]) + ":" + to_string(env[1]);
}

int array grid_size(mixed array grid) {
  return ({ sizeof(grid), sizeof(grid[0]) });
}

mapping cull(mixed array prev, mapping seen) {
  unless(seen) return prev;
  int min_risk = prev[1];
  int risk = accumulate(seen);
  if(risk < min_risk) {
    return ({ seen, risk });
  } else {
    return prev;
  }
}

mapping dfs(int array start, mixed array grid, mapping seen) {
  string k = to_key(start);
  if(member(seen, k)) {
    return 0; // deadending
  }
  seen[k] = grid[start[0]][start[1]];
  if(k == "0:0") {
    seen[k] = 0;
  }
  int array gsize = grid_size(grid);
  if(gsize[0]-1 == start[0] && gsize[1]-1 == start[1]){
    return seen;
  }
  mixed array dirs = filter(({
    ({ start[0]+1, start[1] }),
    ({ start[0]-1, start[1] }),
    ({ start[0], start[1]+1 }),
    ({ start[0], start[1]-1 }),
  }), (: return $1[0] >= 0 && $1[1] >=0 && $1[0] < $2[0] && $1[1] < $2[1]; :), gsize);
  // TODO: Count cost to grid tiles
  mixed array res = reduce(map(dirs, #'dfs, grid, copy(seen)), #'cull, ({ ([]), __INT_MAX__}));
  return res[0];
}

int part1(mixed array grid) {
  mapping seen = ([]);
  mixed seen_risk = cull(({ ([]), __INT_MAX__}), dfs(({0,0}), grid, seen));
  dbg(seen_risk);

  return 0;
}

void configure() {
  ::configure();
  set_day(15);
  mixed array samples = map(to_lines(input("sample")), (: return to_ints(explode($1, "")); :));
  //int array values =
  dbg(part1(samples));
  //dbg(part1(values));
  //dbg(part2(samples));
  //dbg(part2(values));
}
