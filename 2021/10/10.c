inherit "/w/elronuan/aoc/2021/helper";

string pairs(string token) {
  return ([ "(": ")", "[": "]", "{": "}", "<": ">", ")": "(", "]": "[", "}": "{", ">": "<", ])[token];
}
string array closers = ({ ")", "]", "}", ">" });
int score(string token) {
  return ([ ")": 3, "]": 57, "}": 1197, ">": 25137, ])[token];
}
int score2(string token) {
  return ([ ")": 1, "]": 2, "}": 3, ">": 4, ])[token];
}

string array rev_stack(string array tokens) {
  return map(array_reverse(tokens), #'pairs);
}

status closer(string token) {
  return member(closers, token) != -1;
}

mixed check_tokens(string array tokens) {
  string array stack = ({});
  foreach(string token in tokens) {
     if(closer(token)) {
       if(stack[<1] != pairs(token))
         return score(token);
       stack = stack[0..<2];
     } else {
       stack += ({ token });
     }
  }
  return rev_stack(stack);
}

int part1(mixed array lines) {
  return accumulate(filter(map(lines, #'check_tokens), #'intp));
}

int part2(mixed array lines) {
  mixed array stacks = filter(map(lines, #'check_tokens), #'pointerp);
  int array scores = map(stacks, (: return reduce($1, (: return $1 * 5 + score2($2); :)); :));
  return sort_array(scores, #'<)[sizeof(scores)/2];
}

void configure() {
  ::configure();
  set_day(10);
  mixed array samples = map(to_lines(input("sample")), (: return explode($1, ""); :));
  mixed array values = map(to_lines(input(1)), (: return explode($1, ""); :));
  dbg(part1(samples));
  dbg(part1(values));
  dbg(part2(samples));
  dbg(part2(values));
}
