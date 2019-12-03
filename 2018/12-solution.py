#!/usr/bin/env python
import re, operator
from collections import deque

test = False
if test:
    INPUT = "12-input-test.txt"
else:
    INPUT = "12-input.txt"

class Cave(object):
    # initial state: #..#.#..##......###...###
    def __init__(self, initial):
        print(initial)
        p = re.compile(r'initial state: (?P<initial>[#\.]+)$')
        m = p.match(initial)
        self.initial = [c for c in m.group('initial')]
        self.generations = [(0, self.initial)]
        self.rules = {}

    def add_rule(self, rule):
        # ...## => #
        p = re.compile(r'(?P<lhs>[#\.]{5}) => (?P<rhs>[#\.])')
        m = p.match(rule)
        self.rules[tuple(c for c in m.group('lhs'))] = m.group('rhs')

    def spread(self, pattern):
        if pattern in self.rules:
            return self.rules[pattern]
        if not test:
            print("Fail", pattern)
        return '.'
        if pattern == ('.', '.', '.', '.', '.'):
            return None

    def process(self, n=20):
        self.generations = [(0, self.initial)]
        gen_n = 0
        curr = self.sum()
        while gen_n <= n:
            prev = curr
            curr = self.sum()
            print(gen_n, curr, curr - prev)
            if gen_n % 5000000 == 0:
                print("generation", gen_n, gen_n / 50000000000)
            last_gen = self.generations[-1]
            start = last_gen[0]
            new_start = 9999
            lg = last_gen[1]
            gen = []
            rw_backtrack = -2
            rp_backtrack = -2
            while True:
                # .  . -2 -1 0 1 2
                # rp
                #      rw
                rw = start + rw_backtrack + len(gen)
                if rw > -start + len(lg) + 2:
                    break # end when starting to insert beyond end of range
                rp = rw + rp_backtrack
                # print("start", len(self.generations), rw, rp)
                p = []
                while rp < start: # pattern is only . before the start
                    p.append('.')
                    rp += 1
                while len(p) < 5:
                    # print("rp", rp, start, len(lg))
                    # print(lg)
                    lgi = rp - start
                    if lgi >= len(lg):
                        p.append('.')
                    else:
                        p.append(lg[lgi])
                    rp += 1
                pattern = tuple(p)
                res = self.spread(pattern)
                gen.append(res)
                if rw < new_start and res == '#':
                    new_start = rw
            # print('gen', gen)
            gen = [c for c in ''.join(gen).lstrip('.')]
            if new_start >= 0:
                prefix = [c for c in '.' * new_start]
                gen = prefix + gen
                new_start = 0
            self.generations = [ [new_start, tuple([c for c in (''.join(gen).rstrip('.')) ])] ]
            gen_n += 1

    def draw(self):
        for i, gen in enumerate(self.generations):
            fmt = "{:3} {:3} " + (5+gen[0]) * " " + "{}"
            print(fmt.format(i, gen[0], ''.join(gen[1])))

    def sum(self):
        val = 0
        offset = self.generations[-1][0]
        for i, v in enumerate(self.generations[-1][1]):
            if v == '#':
                val += i+offset
        return val

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return "<Cave: Gen{}:\n{}>".format(len(self.generations)-1, "".join(self.generations[-1][1]))


def main():
    lines = [line.rstrip("\n") for line in open(INPUT)]
    cave = Cave(lines[0])
    for line in lines[2:]:
        cave.add_rule(line)
    print(cave)
    cave.process()
    cave.draw()
    val = cave.sum()
    print ("Cave Val: {}".format(val))
    print("3738!!")
    cave.process(50000000000)
    val = 0
    offset = cave.generations[-1][0]
    for i, v in enumerate(cave.generations[-1][1]):
        if v == '#':
            val += i+offset
    print ("Cave Val: {}".format(val))

if __name__ == "__main__":
    main()
