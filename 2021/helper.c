#include <display.h>

string owner;
string query_owner() {
  return owner;
}
void set_owner(string value) {
  owner = value;
}

string year;
string query_year() {
  return year;
}
void set_year(mixed value) {
  year = to_string(value);
}

string day;
string query_day() {
  return day;
}
void set_day(int value) {
  day = sprintf("%02i", value);
}

void dbg(mixed value) {
  find_player(query_owner())->display("/daemon/debug"->dump_value(value));
}

void dbg_grid(mixed value) {
  object o = find_player(query_owner());
  o->display(implode(map(value, (: return implode(map($1, #'to_string), ""); :)), "\n") + "\n", Display_Preformatted);
}

/**
 * Returns string contents of a AOC input identified by the params.
 *
 * @param mixed dat  Data identifier, 0 -> sample.txt, rest: {dat}.txt
 *
 * @return string  Input file contents.
 **/
string input(mixed dat) {
  string file = (dat == 0 ? "sample" : to_string(dat)) + ".txt";
  string path = __DIR__ + query_day() + "/" +  file;
  dbg(path);
  return trim(read_file(path), 0, " \t\n");
}

string array to_lines(string value) {
  return explode(value, "\n");
}

int array to_ints(string array values) {
  return map(values, #'to_int);
}

void bench(closure fn) {

}

void configure() {
  set_year(to_int(explode(__DIR__, "/")[<2]));
  set_owner("elronuan");
}
