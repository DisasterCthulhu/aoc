inherit "/w/elronuan/aoc/2021/helper";

int route(string env, mapping exits, string array from, status pt2) {
  from += ({ env });
  status lower = lower_case(env) == env;
  int prev = sizeof(filter(from, (: return $1 == $2; :), env));
  if(lower && !pt2 && prev == 2) {
    return 0;
  }
  if(env == "end") {
    // Display found path
    //dbg(implode(from, ", "));
    return 1;
  }
  string array options = copy(exits[env]);
  unless(options) {
    return 0;
  }
  if(lower) {
    if(!pt2 || prev == 2) {
      pt2 = False;
      exits = m_delete(deep_copy(exits), env);
    }
  }
  return accumulate(map(options, #'route, exits, from, pt2));
}

int part1(mixed array conns, status pt2) {
  mapping exits = ([]);
  foreach(string array pair in conns) {
    if(exits[pair[0]]) {
      if(member(exits[pair[0]], pair[1]) == -1) {
        exits[pair[0]] = sort_array(exits[pair[0]] + ({ pair[1] }), #'>);
      }
    } else {
      exits[pair[0]] = ({ pair[1] });
    }
    if(exits[pair[1]]) {
      if(member(exits[pair[1]], pair[0]) == -1) {
        exits[pair[1]] = sort_array(exits[pair[1]] + ({ pair[0] }), #'>);
      }
    } else {
      exits[pair[1]] = ({ pair[0] });
    }
  }
  //dbg(exits);
  string array options = copy(exits["start"]);
  //dbg(options);
  int score = accumulate(
      map(options, #'route, m_delete(deep_copy(exits), "start"), ({ "start" }), pt2)
    );
  return score;
}

void configure() {
  ::configure();
  set_day(12);
  mixed array samples = map(to_lines(input("sample")), (: return explode($1, "-"); :));
  mixed array values = map(to_lines(input(1)), (: return explode($1, "-"); :));
  dbg(part1(samples, False));
  dbg(part1(values, False));
  //dbg(part1(samples, True));
  //dbg(part1(values, True));
}
