inherit "/w/elronuan/aoc/2021/helper";

int part1(int array values, int window) {
  int incr = 0;
  int len = sizeof(values);
  for(int i = window; i < len; i++) {
    if(values[i-window] < values[i]) {
      incr++;
    }
  }
  return incr;
}

void configure() {
  ::configure();
  int array samples = to_ints(to_lines(input("sample")));
  int array values = to_ints(to_lines(input(1)));
  int window = 1;
  dbg(part1(samples, window));
  dbg(part1(values, window));
  window = 3;
  dbg(part1(samples, window));
  dbg(part1(values, window));
}
