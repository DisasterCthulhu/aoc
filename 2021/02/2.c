inherit "/w/elronuan/aoc/2021/helper";

mixed array to_commands(string array commands) {
  return map(commands, (:
    mixed  array x = explode($1, " ");
    return ({ to_string(x[0]), to_int(x[1]) });
  :));
}

int part1(mixed array commands) {
  int depth = 0, horiz = 0;
  // wtf, foreach doesn't destructure arrays?
  foreach(mixed arr: commands) {
    string dir = arr[0];
    int dist = arr[1];
    switch(dir) {
      case "up":
        depth -= dist;
        break;
      case "down":
        depth += dist;
        break;
      case "forward":
        horiz += dist;
        break;
    }
  }
  return (depth * horiz);
}

int part2(mixed array commands) {
  int depth = 0, horiz = 0;
  int aim = 0;
  // wtf, foreach doesn't destructure arrays?
  foreach(mixed arr: commands) {
    string dir = arr[0];
    int dist = arr[1];
    switch(dir) {
      case "up":
        aim -= dist;
        break;
      case "down":
        aim += dist;
        break;
      case "forward":
        horiz += dist;
        depth += aim * dist;
        break;
    }
  }
  return (depth * horiz);
}

void configure() {
  set_day(2);
  ::configure();
  mixed array samples = to_commands(to_lines(input("sample")));
  dbg(samples);
  mixed array values = to_commands(to_lines(input(1)));
  int window = 1;
  dbg(part1(samples));
  dbg(part1(values));
  dbg(part2(samples));
  dbg(part2(values));
}
