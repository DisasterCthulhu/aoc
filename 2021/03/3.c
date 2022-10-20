inherit "/w/elronuan/aoc/2021/helper";

mapping count_bits(int array report) {
  int width = sizeof(report[0]);
  mapping counts = ([:2]);
  foreach(int array bits in report) {
    for(int i = 0; i < width; i++)
      counts[i, bits[i]]++;
  }
  return counts;
}

int part1(int array report) {
  int width = sizeof(report[0]);
  mapping counts = count_bits(report);
  int gamma; // high count bits
  int epsilon; // low count bits
  for(int pos = 0; pos < width; pos++) {
    int bitpos = width - pos - 1;
    int zero = counts[pos, 0];
    int one = counts[pos, 1];
    int val = to_int(pow(2, bitpos));
    if (one > zero) {
      gamma += val;
    } else {
      epsilon += val;
    }
  }
  return epsilon * gamma;
}

int filter_partial(int array values, int array prefix, int end) {
  for(int i = 0; i < end+1; i++) {
    if(prefix[i] != values[i]) {
      return False;
    }
  }
  return True;
}

int bits_to_int(int array bits) {
  int width = sizeof(bits);
  int res = 0;
  for(int pos = 0; pos < width; pos++) {
    int bitpos = width - pos - 1;
    if(bits[pos]) {
      res += to_int(pow(2, bitpos));
    }
  }
  return res;
}

int part2(int array report) {
  int width = sizeof(report[0]);
  mixed array res = ({ ({}), ({}) });
  for(int lh = 0; lh < 2; lh++) {
    int array working = report;
    for(int pos = 0; pos < width; pos++) {
      if(sizeof(working) == 1) {
        res[lh] = working[0];
        break;
      }
      mapping counts = count_bits(working);
      int zero = counts[pos, 0];
      int one = counts[pos, 1];
      if(one >= zero && lh == 1 || zero > one && lh == 0) {
        res[lh] += ({ 1 });
      } else {
        res[lh] += ({ 0 });
      }
      working = filter(working, #'filter_partial, res[lh], pos);
    }
  }
  return bits_to_int(res[0]) * bits_to_int(res[1]);
}

int parse(string line) {
  return map(explode(line, ""), #'to_int);
}

void configure() {
  ::configure();
  set_day(3);
  int array samples = map(to_lines(input("sample")), #'parse);
  int array values = map(to_lines(input(1)), #'parse);
  dbg(samples);
  dbg(part1(samples));
  dbg(part1(values));
  dbg(part2(samples));
  dbg(part2(values));
}
