#!/usr/bin/env python
import re, operator
from collections import deque
test = False
if test:
    INPUT = "9-input-test.txt"
else:
    INPUT = "9-input.txt"

CW = -1
CCW = 1

class Marbles(object):
    def __init__(self, line):
        p = re.compile(r'(?P<players>\d+) players; last marble is worth (?P<points>\d+) points(: high score is (?P<score>\d+)|)')
        m = p.match(line)
        self.players = int(m.group('players'))
        self.points = int(m.group('points'))
        self.score = 0
        if m.group('score'):
            self.score = int(m.group('score'))

    def play(self):
        self.circle = deque([0])
        elves = [0 for _ in range(self.players)]
        turn = 0
        marble = 0
        while True:
            val = 0
            marble += 1
            if marble % 23 == 0:
                self.circle.rotate(CCW * 7)
                val += self.circle.pop()
                val += marble
                elves[turn] += val
                self.circle.rotate(CW)
            else:
                self.circle.rotate(CW * 1)
                self.circle.append(marble)
            if marble >= self.points:
                break
            turn = (turn + 1) % self.players
        hs = max(elves)
        print("High score:", hs)
        if self.score == 0:
            self.score = hs
        else:
            if self.score == hs:
                print("Found Actual HS:", hs)
        print(self)

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return "<Marbles: Players {} Points {} Score {}>".format(self.players, self.points, self.score)

def main():
    lines = [line.strip("\n") for line in open(INPUT)]
    for line in lines:
        marble = Marbles(line)
        marble.play()
        marble = Marbles(line)
        marble.points = marble.points * 100
        marble.play()

if __name__ == "__main__":
    main()
