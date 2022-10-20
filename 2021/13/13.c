inherit "/w/elronuan/aoc/2021/helper";

mapping fold(mapping dots, string array inst) {
  int axis = inst[0] == "x" ? 1 : 0;
  int pos = to_int(inst[1]);
  mapping paper = ([]);
  foreach(string key, string val in dots) {
    if(val[axis] > pos) {
      val[axis] = 2 * pos - val[axis];
    }
    key = val[0] + "," + val[1];
    paper[key] = val;
  }
  return paper;
}

void disp(mapping dots) {
  string array lines = ({});
  for(int i = 0; i < 9; i++) {
    lines += ({"." * 40});
  }
  foreach(string key, int array val in dots) {
    lines[val[0]][val[1]] = "X"[0];
  }
  dbg(lines);
}


int part1(mixed array paper) {
  mapping dots = paper[0];
  mixed array folds = paper[1];
  foreach(string array inst in folds) {
    dots = fold(dots, inst);
    // one fold for pt1
    //break;
  }
  dbg(sizeof(dots));
  disp(dots);
  return 0;
}

mixed array parse(string array lines) {
  mapping coords = ([]);
  mixed array folds = ({ });
  foreach(string line in lines) {
    if(line == "") continue;
    if(begins_with(line, "fold")) {
      folds += ({ explode(line[11..], "=") });
    } else {
      int array x_y = to_ints(explode(line, ","));
      coords[x_y[1] + "," +  x_y[0]] = ({ x_y[1], x_y[0] });
    }
  }
  return ({ coords, folds });
}

void configure() {
  ::configure();
  set_day(13);
  mixed array samples = parse(to_lines(input("sample")));
  mixed array paper = parse(to_lines(input(1)));
  //int array values =
  dbg(part1(samples));
  dbg(part1(paper));
  //dbg(part2(samples));
  //dbg(part2(values));
}
