inherit "/w/elronuan/aoc/2021/helper";

status is_low(int y, int x, int my, int mx, mixed array heightmap) {
  int height = heightmap[y][x];
  mixed array neighbors = ({
      ({ 1, 0 }),
      ({ -1, 0 }),
      ({ 0, 1 }),
      ({ 0, -1 }),
    });
  foreach(int array pos in neighbors) {
    int ny = y + pos[0];
    int nx = x + pos[1];
    if(ny < 0 || nx < 0) continue;
    if(ny >= my || nx >= mx) continue;
    if(height == heightmap[ny][nx]) {
      return False;
    }
    if(height > heightmap[ny][nx]) return False;
  }
  return True;
}

mapping find_lows(mixed array heightmap) {
  int my = sizeof(heightmap);
  int mx = sizeof(heightmap[0]);
  mapping lows = ([]);
  for(int y = 0; y < my; y++) {
    for(int x = 0; x < mx; x++) {
      if(is_low(y, x, my, mx, heightmap)) {
        lows[({y, x})] = heightmap[y][x];
      }
    }
  }
  return lows;
}

int part1(mixed array heightmap) {
  mapping lows = find_lows(heightmap);
  return accumulate(lows) + sizeof(lows);
}


mixed array get_neighbors(int array search, mixed array heightmap) {
  int my = sizeof(heightmap);
  int mx = sizeof(heightmap[0]);
  int y = search[0];
  int x = search[1];
  mixed array neighbors = ({
      ({ 1, 0 }),
      ({ -1, 0 }),
      ({ 0, 1 }),
      ({ 0, -1 }),
    });
  mixed array found = ({});
  foreach(int array pos in neighbors) {
    int ny = y + pos[0];
    int nx = x + pos[1];
    if(ny < 0 || nx < 0) continue;
    if(ny >= my || nx >= mx) continue;
    if(heightmap[ny][nx] == 9) {
      continue;
    }
    found += ({ ({ ny, nx }) });
  }
  return found;
}

mixed array filter_list(mixed array list, mixed array values) {
  foreach(mixed val in values) {
    list = filter(list, (: return !identical($1, val); :));
  }
  return list;

}

mapping get_basin(int array start, mixed array heightmap) {
  mixed array basin = ({ start });
  mixed array queue = ({ start });
  int rounds = 2;
  do {
    int array pos = queue[0];
    array_remove(&queue, pos);
    array_require(&basin, pos);
    mixed array neighbors = get_neighbors(pos, heightmap);
    neighbors = filter_list(neighbors, queue);
    neighbors = filter_list(neighbors, basin);
    foreach(int array n in neighbors) {
      // add pos after getting its neighbors, queue neighbors
      array_require(&queue, n);
    }
  } while(sizeof(queue));
  return basin;

}
int part2(mixed array heightmap) {
  mapping lows = find_lows(heightmap);
  mapping basins = map(lows, (: return get_basin($1, heightmap); :));
  basins = map(basins, (: return sizeof($2); :));
  while(sizeof(basins) > 3) {
    int m = min(m_values(basins));
    basins = filter(basins, (: return $2 != m; :));
  }
  int prod = 1;
  foreach(mixed k, int v in basins) {
    prod *= v;
  }
  return prod;
}


mixed array parse(string array lines) {
  return map(lines, (: return map(explode($1, ""), #'to_int); :));
}

void configure() {
  ::configure();
  set_day(9);
  mixed array samples = parse(to_lines(input("sample")));
  mixed array values = parse(to_lines(input(1)));
  dbg(part1(samples));
  dbg(part1(values));
  dbg(part2(samples));
  dbg(part2(values));
}
