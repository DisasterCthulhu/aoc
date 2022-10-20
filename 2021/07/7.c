inherit "/w/elronuan/aoc/2021/helper";

mapping costs;

int fuel_cost(int array crabs, int dest) {
  int cost = reduce(crabs, (:
        return $1 + abs($2 - dest);
        :),
      0);
  dbg(({ dest, cost, }));
  return cost;
}

int query_cost(int crab_dist) {
  if(costs[crab_dist])
    return costs[crab_dist];
  int cost = 0;
  for(int i = 1; i <= crab_dist; i++) {
    cost += i;
  }
  costs[crab_dist] = cost;
  return cost;

}

int crab_cost(int array crabs, int dest) {
  int cost = reduce(crabs, (:
        return $1 + query_cost(abs($2 - dest));
        :),
      0);
  dbg(({ dest, cost, }));
  return cost;

}

int part1(int array crabs, closure fn) {
  costs = ([]);
  int cnt = sizeof(crabs);
  int mid = sort_array(crabs, #'<)[cnt/2];
  int base_cost = apply(fn, crabs, mid);
  status higher = apply(fn, crabs, mid+1) > base_cost;
  status lower = apply(fn, crabs, mid-1) > base_cost;
  int s = 0;
  if (higher || lower) {
    s = higher < lower ? 1 : -1;
  }
  int step = 1;
  while(s && step > 0) {
    dbg(({ "while", s, step, mid }));
    int cost = apply(fn, crabs, mid + s * step);
    int adv = apply(fn, crabs, mid + s * step * 2);
    if(adv > cost && s != 1) {
      step = step / 10;
      continue;
    }
    if(cost > base_cost) {
      if(step == 1) {
        s = 0;
      }
      mid += step * s;
      step = step / 10;
    } else {
      mid = mid + s * step;
      base_cost = cost;
    }
  }

  dbg(({ base_cost, higher, lower }));
   //dbg(costs);

  return base_cost;
}

void configure() {
  ::configure();
  set_day(7);
  int array samples = to_ints(explode(input("sample"), ","));
  int array values = to_ints(explode(input(1), ","));
  dbg(part1(samples, #'fuel_cost));
  dbg(part1(values, #'fuel_cost));
  // 325,528
  dbg(part1(samples, #'crab_cost));
  dbg(part1(values, #'crab_cost));
  // 85,016,864 not
  //dbg(part2(values));
}
