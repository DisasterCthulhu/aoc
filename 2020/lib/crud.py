"""Input stuff
"""


def slurp(s):
    return s.split("\n\n")


def ints(s: str):
    return [int(x) for x in s.splitlines(False)]


def cat(filename):
    with open(filename) as file:
        return file.read()
