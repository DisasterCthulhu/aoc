from lib import *


def datafile():
    return "input/08"


class Program:
    def __init__(self, code):
        self.code = [(x.split()) for x in code]
        self.accumulator = 0
        self.visited = set([])
        self.ip = 0

    def ops(self, op):
        return {"jmp": self.jmp, "nop": self.nop, "acc": self.acc}[op]

    def run(self):
        end = len(self.code)
        while True:
            if self.ip >= end:
                break
            if self.ip in self.visited:
                break
            self.visited.add(self.ip)
            (op, amt) = self.code[self.ip]
            self.ops(op)(amt)

        return (self.accumulator, self.ip >= end)

    def acc(self, amt):
        self.accumulator += int(amt)
        self.ip += 1

    def nop(self, _):
        self.ip += 1

    def jmp(self, offset):
        self.ip += int(offset)


@microbench
def part1(data):
    p = Program(data.splitlines())
    (acc, end) = p.run()
    print(f"{acc}, {end}")
    return acc


@microbench
def part2(data):
    data = data.splitlines()
    tgt = 0
    l = len(data)
    while tgt < l:
        p = Program(data)
        op = p.code[tgt][0]
        if op == "nop":
            p.code[tgt][0] = "jmp"
        elif op == "jmp":
            p.code[tgt][0] = "nop"
        (acc, end) = p.run()
        if end:
            return acc
        tgt += 1
