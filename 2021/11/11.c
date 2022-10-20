inherit "/w/elronuan/aoc/2021/helper";
#define State_Dumbos 0
#define State_Round 1
#define State_Flashes 2
#define State_Fields 3

#define State_New allocate(State_Fields)

#define Dumbo_Energy 0
#define Dumbo_Flashed 1
#define Dumbo_Fields 2

#define Dumbo_New(energy) ({ energy, False })

record dumbo_charge(record dumbo) {
  dumbo[Dumbo_Energy] += 1;
  return dumbo;
}

record dumbo_reset(record dumbo) {
  if(dumbo[Dumbo_Flashed]) {
    dumbo[Dumbo_Energy] = 0;
  }
  dumbo[Dumbo_Flashed] = 0;
  return dumbo;
}

int dumbo_flashed(record dumbo) {
  return dumbo[Dumbo_Flashed];
}

record map_dumbos(record state, closure fn) {
  state[State_Dumbos] = map(state[State_Dumbos], (:
      return map($1, (:
          return funcall(fn, $1);
        :));
    :));
  return state;
}

record flash(record state, int y, int x) {
  mixed array dumbos = state[State_Dumbos];
  state[State_Dumbos][y][x][Dumbo_Flashed] = True;
  for(int iy = y-1; iy <= y+1; iy++) {
    if(iy < 0 || iy > 9) continue;
    for(int ix = x-1; ix <= x+1; ix++) {
      if(ix < 0 || ix > 9) continue;
      state[State_Dumbos][iy][ix][Dumbo_Energy] += 1;
    }
  }
  return state;
}

record flashy(record state) {
  status flashed;
  do {
    flashed = False;
    for(int y = 0; y < 10; y++) {
      for(int x = 0; x < 10; x++) {
        record dumbo = state[State_Dumbos][y][x];
        if(dumbo[Dumbo_Energy] > 9 && !dumbo[Dumbo_Flashed]) {
          flashed = True;
          state = flash(state, y, x);
        }
      }
    }
  } while(flashed);
  return state;
}

record count_flashes(record state) {
  int flashes = state[State_Flashes];
  state = reduce(state[State_Dumbos], (:
      mixed acc = accumulate(map($2, #'dumbo_flashed));
      $1[State_Flashes] += acc;
      return $1;
    :), state);
  int end_flashes = state[State_Flashes];
  if(100 == end_flashes - flashes) {
    dbg(({ "100 flashes: ", state[State_Round] }));
  }
  return state;
}

int part1(mixed array octopodes, int limit) {
  record state = State_New;
  state[State_Dumbos] =  map(octopodes, (: return map($1, (: return Dumbo_New($1); :)); :));
  for(int i = 0; i < limit; i++) {
    state[State_Round]++;
    state = map_dumbos(state, #'dumbo_charge);
    state = flashy(state);
    state = count_flashes(state);
    state = map_dumbos(state, #'dumbo_reset);
  }
  return state[State_Flashes];
}

void configure() {
  ::configure();
  set_day(11);
  int array samples = map(to_lines(input("sample")), (: return map(explode($1, ""), #'to_int); :));
  int array values = map(to_lines(input(1)), (: return map(explode($1, ""), #'to_int); :));
  dbg(part1(samples, 100));
  dbg(part1(values, 100));
  //dbg(part2(samples));
  dbg(part1(values, 365));
}
