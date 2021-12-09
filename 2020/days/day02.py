from lib import *

def datafile():
    return "input/02"

def parse_line(line):
    # 6-7 z: dqzzzjbzz
    (rule, password) = line.split(": ")
    (low, high, char) = rule.replace("-", " ").split(" ")
    return (int(low), int(high), char, password)

def parse(data):
    return map(parse_line, data.splitlines())

def validate_sled(low, high, char, password):
    return low <= password.count(char) <= high

@microbench
def part1(data):
    valid = 0
    for rules in parse(data):
        if validate_sled(*rules):
            valid += 1
    return valid

def matches(char, pos, password):
    return password[pos - 1] == char

def validate_toboggan(low, high, char, password):
    valid = [matches(char, low, password), matches(char, high, password)]
    return any(valid) and not all(valid)

@microbench
def part2(data):
    valid = 0
    for rules in parse(data):
        if validate_toboggan(*rules):
            valid += 1
    return valid
