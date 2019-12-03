#!/usr/bin/env python
import re, operator
if False:
    TIME_BASE = 0
    WORKERS = 2
    INPUT = "7-input-test.txt"
else:
    TIME_BASE = 60
    WORKERS = 5
    INPUT = "7-input.txt"

paths = {}
nodes = {}
visited = set()

def find_end(paths):
    s = set(paths)
    for vs in paths.values():
        for v in vs:
            if v not in s:
                return v

def split_paths(paths):
    lhs = set()
    rhs = set()
    for k, vs in paths.items():
        lhs.add(k)
        for v in vs:
            rhs.add(v)
    return (lhs, rhs)

def cost(node):
    return ord(node) - ord('A') + 1 + TIME_BASE

def find_steps(paths):
    path = ""
    (lhs, rhs) = split_paths(paths)
    for node in lhs | rhs:
        nodes[node] = cost(node)
    print('nodes', nodes)
    visited = set()
    secs = 0
    working_set = set()
    while len(nodes.keys() - visited):
        potential_to_visit = sorted(nodes.keys() - visited - rhs)
        # print(working_set, potential_to_visit)
        while len(potential_to_visit) > 0 and len(working_set) < WORKERS:
            working_set.add(potential_to_visit.pop())
        any_done = False
        for node in sorted(working_set):
            nodes[node] -= 1
            if nodes[node] == 0:
                print(secs, working_set, path)
                working_set.remove(node)
                if not any_done:
                    any_done = node
        secs += 1
        if any_done == False:
            continue
        to_visit = any_done
        print('Adding:', to_visit)
        path += to_visit
        visited.add(to_visit)
        if to_visit in paths:
            del paths[to_visit]
        (lhs, rhs) = split_paths(paths)
    if path == 'GJFMNWBCDHIVETUQYALSPXZORK':
        print('still wrong')
    return (path, secs)

def main():
    lines = [line.rstrip("\n") for line in open(INPUT)]
    p = re.compile(r'Step (?P<lhs>[^ ]+) must be finished before step (?P<rhs>[^ ]+) can begin.')
    for line in lines:
        m = p.match(line)
        lhs = m.group('lhs')
        rhs = m.group('rhs')
        if lhs not in paths:
            paths[lhs] = []
        paths[lhs].append(rhs)
    print(find_steps(paths))


if __name__ == "__main__":
    main()
