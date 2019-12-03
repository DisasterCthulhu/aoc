#!/usr/bin/env python
import re, operator

paths = {}
nodes = set()
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

def find_steps(paths):
    path = ""
    (lhs, rhs) = split_paths(paths)
    nodes = lhs | rhs
    print('nodes', nodes)
    visited = set()
    while len(paths):
        print('Path: ', path)
        to_visit = sorted(nodes - visited - rhs)[0]
        path += to_visit
        print('Adding:', to_visit)
        visited.add(to_visit)
        del paths[to_visit]
        (lhs, rhs) = split_paths(paths)

    print('adding unvisited nodes', nodes-visited)
    path = path + "".join(sorted(nodes - visited))
    if path == 'GJFMNWBCDHIVETUQYALSPXZORK':
        print('still wrong')
    return path

def main():
    lines = [line.rstrip("\n") for line in open('7-input.txt')]
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
