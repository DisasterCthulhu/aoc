inherit "/w/elronuan/aoc/2021/helper";

mapping decode(string line) {
  string array parts = explode(line, " | ");
  string array display = map(explode(parts[1], " "), (:
        return implode(sort_array(explode($1, ""), #'<), "");
      :));
  string array src = explode(parts[0], " ");
  // int keys are int -> segments
  // string single char keys are segments,
  // string int keys have a string array of segments that possibly match to that display val
  mapping ssds = ([]);
  foreach(string ssd in src) {
    ssd = implode(sort_array(explode(ssd, ""), #'<), "");
    switch(sizeof(ssd)) {
      case 2: // 1
        ssds[1] = ssd;
        break;
      case 3: // 7
        ssds[7] = ssd;
        break;
      case 4: // 4
        ssds[4] = ssd;
        break;
      case 5: // 2, 3, 5
        ssds["235"] ||= ({});
        ssds["235"] += ({ ssd });
        break;
      case 6: // 0, 9, 6
        ssds["069"] ||= ({});
        ssds["069"] += ({ ssd });
        break;
      case 7: // 8
        ssds[8] = ssd;
        break;
    }
  }
  // 235 & 1 -> 3 (3 contains 1)
  ssds[3] = filter(ssds["235"], (: return sizeof($1 & $2) == 2; :), ssds[1])[0];
  // 7 - segments[1] -> a
  ssds["a"] = ssds[7] - ssds[1];
  // 069 ^ 1 -> 6 (6 loses 1 segment) f
  ssds[6] = filter(ssds["069"], (: return sizeof($1 - $2) == sizeof($1) - 1; :), ssds[1])[0];
  ssds["f"] = ssds[1] - ssds[6];
  // 1 - f -> c
  ssds["c"] = ssds[1] - ssds["f"];
  // known: 1, 3, 4, 7, 8
  // .....: c, f, a
  // 235 ~ c -> 2, 5, b, e
  ssds[2] = filter(ssds["235"] - ({ ssds[3] }), (:
        return sizeof($1 & $2) == 0;
      :), ssds["c"])[0];
  ssds[5] = filter(ssds["235"] - ({ ssds[3] }), (:
        return sizeof($1 & $2) == 1; :),
      ssds["c"])[0];
  // (d, g common, 4 - 2 - a -> g, d)
  // known: a, b, c, d, e, f, g
  // .....: 1, 2, 3, 4, 5, 6, 7, 8
  ssds[0] = filter(ssds["069"] - ({ ssds[6] }), (:
        return sizeof($1 - $2) == 3;
      :), ssds[4])[0];
  ssds[9] = filter(ssds["069"] - ({ ssds[6] }), (:
        return sizeof($1 - $2) == 2;
      :), ssds[4])[0];
  // last -> 9
  mapping code = ([]);
  for(int i = 0; i < 10; i++) {
    code[ssds[i]] = i;
  }
  //dbg(({code, display}));
  return map(display, (: return $2[$1]; :), code);
  return code;
}

int part1(mixed ssd_lines) {
  int cnt = 0;
  int tot = 0;
  foreach(int array res in map(ssd_lines, #'decode)) {
    int x = res[0] * 1000 + res[1] * 100 + res[2] * 10 + res[3];
    tot += x;
    for(int i = 0; i < 4; i++) {
      if(member(({1, 4, 7, 8}), res[i]) != -1)  {
        cnt++;
      }
    }
  }
  return ({ cnt, tot });
}

void configure() {
  ::configure();
  set_day(8);
  string array samples = to_lines(input("sample"));
  string array values = to_lines(input(1));
  dbg(part1(samples));
  dbg(part1(values));
  //dbg(part2(samples));
  //dbg(part2(values));
}
