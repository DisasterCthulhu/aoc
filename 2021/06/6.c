inherit "/w/elronuan/aoc/2021/helper";

int part1(int array fishes, int limit) {
  dbg(({0 , fishes, ({})}));
  for(int days = 1; days <= limit; days++) {
    int array spawned = allocate(count(fishes, (: return $1 == 0; :)), 8);
    fishes = map(fishes,
        (:
          if($1 == 0) {
            spawned += ({ 8 });
            return 6;
          }
          return --$1;
        :));
    fishes += spawned;
//    dbg(({ days, fishes }));
  }
  return sizeof(fishes);
}

int part2(int array lanternfish, int limit) {
  int array fishies = allocate(9, 0);
  foreach(int f in  lanternfish) {
    fishies[f]+=1;
  }
  for(int days = 1; days <= limit; days++) {
    int spawned = fishies[0];
    fishies = fishies[1..6] + ({ fishies[0] + fishies[7] }) + ({ fishies[8] }) + ({ fishies[0] });
    //dbg(({ days, fishies }));
  }
  return accumulate(fishies);
}

void configure() {
  ::configure();
  set_day(6);
  int array samples = to_ints(explode(input("sample"), ","));
  int array values = to_ints(explode(input(1), ","));
  dbg(part1(samples, 80));
  //dbg(part1(values, 80));
  dbg(part2(samples, 256));
  dbg(part2(values, 256));
}
