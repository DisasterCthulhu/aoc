#!/usr/bin/env python
import re, operator
test = False
if test:
    INPUT = "8-input-test.txt"
else:
    INPUT = "8-input.txt"

class Node(object):
    def __init__(self, data):
        self.child_nodes = data[0]
        self.entries = data[1]
        self.children = []
        self.data = []
        if self.child_nodes:
            self.data = self.process_data(data[2:])
        else:
            self.data = data[2:(2+self.entries)]

    def process_data(self, data):
        skip = 0
        for i in range(self.child_nodes):
            child = Node(data[skip:])
            skip += child.size()
            self.children.append(child)
        return data[skip:(skip+self.entries)]

    def size(self):
        sz = 2 + self.entries
        for child in self.children:
            sz += child.size()
        return sz

    def checksum(self):
        chksum = 0
        for v in self.data:
            chksum += v
        for child in self.children:
            chksum += child.checksum()
        return chksum

    def value(self):
        if self.child_nodes == 0:
            return  self.checksum()
        val = 0
        for d in self.data:
            if d <= self.child_nodes and d > 0:
                val += self.children[d-1].value()
        return val

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return "<Node: Children: {}, Entries: {}>".format(self.child_nodes, self.data)

def main():
    line = [line.strip("\n") for line in open(INPUT)][0]
    data = [int(d) for d in line.split(" ")]
    root = Node(data)
    print("A: checksum:", root.checksum())
    print("B: Value:", root.value())

if __name__ == "__main__":
    main()
