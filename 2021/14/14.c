inherit "/w/elronuan/aoc/2021/helper";

mixed array process(mapping template, mapping polymer, mapping pairs) {
  mapping work = ([]);
  foreach(string key, int count in polymer) {
    string element = pairs[key];
    string base = key[0..0] + element;
    string chain = element + key[1..1];
    work[base] += count;
    work[chain] += count;
    template[element] += count;
  }
  return ({template, work});
}

int score(mapping polymer) {
  //dbg(({ polymer, min(values(polymer)), max(values(polymer)) }));
  return max(values(polymer)) - min(values(polymer));
}

int part1(mixed array rules, int rounds) {
  mapping template = ([]);
  string start = rules[0];
  for(int i = 0; i < sizeof(start); i++) {
    template[start[i..i]]++;
  }
  mapping polymer = rules[1];
  mapping pairs = rules[2];
  for(int round = 0; round < rounds; round++) {
    mixed array res = process(template, polymer, pairs);
    template = res[0];
    polymer = res[1];
    score(template);
  }
  return score(template);
}

mixed array parse(string array lines) {
  string template = lines[0];
  mapping pairs = ([]);
  foreach(string line in lines[2..]) {
    string array pair = explode(line, " -> ");
    pairs[pair[0]] = pair[1];
  }
  mapping polymer = ([]);
  int len = sizeof(template);
  for(int i = 0; i < len-1; i++) {
    polymer[template[i..i+1]]++;
  }
  return ({ template, polymer, pairs });
}

void configure() {
  ::configure();
  set_day(14);
  mixed array samples = parse(to_lines(input("sample")));
  mixed array value = parse(to_lines(input(1)));
  dbg(part1(samples, 10));
  dbg(part1(value, 10));
  dbg(part1(samples, 40));
  dbg(part1(value, 40));
}
