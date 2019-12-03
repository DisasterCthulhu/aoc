#!/usr/bin/env python
import operator
import re
from collections import deque

TEST = 1
if TEST == 1:
    INPUT = "14-input-test.txt"
else:
    INPUT = "14-input.txt"

class Elf(object):
    def __init__(self, eid):
        self.eid = eid
        self.idx = eid # initial index matches id
        self.score = 0

    def cook(self, scores):
        self.score = scores[self.idx]
        return self

    def advance(self, limit):
        self.idx = (self.idx + 1 + self.score) % limit

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return "<Elf#{} idx:{}, score:{}>".format(self.eid, self.idx, self.score)

def main():
    """main"""
    limit = '880751'
    search = [int(c) for c in limit]
    slen = len(search)
    scores = [int(c) for c in [line.rstrip("\n") for line in open(INPUT)][0]]
    print("Limit", limit, "Scores", scores)
    elves = [Elf(idx) for idx in [0, 1]]
    found = False
    ilimit = int(limit) + 10
    cnt = len(scores)
    while (cnt < ilimit) or found == False:
        round_scores = [elf.cook(scores).score for elf in elves]
        for c in str(sum(round_scores)):
            scores.append(int(c))
            cnt += 1
            if cnt < slen:
                continue
            if int(c) == search[-1] and scores[-slen] == search[0] and scores[-slen:] == search:
                print("Found at ", len(scores))
                found = True
        for elf in elves:
            elf.advance(cnt)
    after_result = ''.join([str(c) for c in scores[ilimit-10:ilimit]])
    print(after_result)
    result = ''.join([str(c) for c in scores])
    print(result.index(limit))




if __name__ == "__main__":
    main()
