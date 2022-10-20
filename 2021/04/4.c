inherit "/w/elronuan/aoc/2021/helper";

int array to_boards(string array lines) {
  string array chunks = explode(implode(lines, "\n"), "\n\n");
  return map(
      chunks,
      (:
        return to_ints(explode(
            replace(replace(replace($1, "\n", " "), "  ", " "), "  ", " "),
          " "));
      :)
    );

}

status check_board(int array called, int array board) {
  // check for horiz / vertical bingo. board is 25 ints across. idx * / % is fine
  for(int i = 0; i < 5; i++) {
    // row 0..4 chunks
    if(all(board[(i*5)..(i*5+4)], (:
        return member($2, $1) != -1;
      :), called)) {
      return True;
    }
    // col chunks
    if(all(({board[0+i], board[5+i], board[10+i], board[15+i], board[20+i] }), (:
        return member($2, $1) != -1;
      :), called)) {
      return True;
    }
  }
  return False;
}

int check_boards(int array called, mixed array boards) {
  int len = sizeof(boards);
  for(int i = 0; i < len; i++) {
    if(boards[i]) {
      if(check_board(called, boards[i])) {
        return i;
      }
    }
  }
  return -1;
}

int part1(string array bingo) {
  int array numbers = to_ints(explode(bingo[0], ","));
  bingo = bingo[2..];
  mixed array boards = to_boards(bingo);
  int len = sizeof(numbers);
  for(int i=0; i < len; i++) {
    int board = check_boards(numbers[0..i], boards);
    if(board != -1) {
      int array left = filter(boards[board], (:
          return member($2, $1) == -1;
        :), numbers[0..i]);
      int sum = reduce(left, (: return $1 + $2; :));
      return sum * numbers[i];
    }
  }
  //dbg(({ numbers, boards }));
  return -1;
}

int part2(string array bingo) {
  int array numbers = to_ints(explode(bingo[0], ","));
  bingo = bingo[2..];
  mixed array boards = to_boards(bingo);
  int len = sizeof(numbers);
  mapping done = ([]);
  int i = 0;
  for(i; i < len; i++) {
    int blen = sizeof(boards);
    for(int bi = 0; bi < blen; bi++) {
      if(boards[bi]) {
        if(done[bi] < 1 && check_board(numbers[0..i], boards[bi])) {
          done[bi] = i; //numbers[i];
          if(sizeof(done) < sizeof(boards)) {
            boards[bi] = 0;
          }
        }
      }
    }
  }
  for(int b=0; b < sizeof(boards); b++) {
    if(boards[b]) {
      int array left = filter(boards[b], (:
          return member($2, $1) == -1;
        :), numbers[0..(done[b])]);
      int sum = reduce(left, (: return $1 + $2; :));
      //dbg( ({ b, left, sum, numbers[done[b]] }));
      return sum * numbers[done[b]];
    }
  }
  //dbg(({ numbers, boards, done }));
  return -1;
}

void configure() {
  ::configure();
  set_day(4);
  string array samples = to_lines(input("sample"));
  string array values = to_lines(input(1));
  dbg(part1(samples));
  dbg(part1(values));
  dbg(part2(samples));
  dbg(part2(values));
}
