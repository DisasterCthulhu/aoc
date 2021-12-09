from lib import *

def datafile():
    return "input/07"

def parse_rules(data):
  rules = {}
  for rule in data.replace('.', '').splitlines():
    m = re.match("(?P<container>.*) bags contain (?P<contents>.*)", rule)
    contents = {}
    for content in m['contents'].replace(' bags', '').replace(' bag', '').split(', '):
      if content != "no other":
        c = re.match("(?P<qty>\d+) (?P<color>.*)", content).groupdict()
        contents[c['color']] = int(c['qty'])
    rules[m['container']] = contents
  return rules

@microbench
def part1(data):
  rules = parse_rules(data)
  target = "shiny gold"
  containers = set()
  for (k, v) in rules.items():
    if target in v:
      containers.add(k)

  while True:
    l = len(containers)
    for c in containers.copy():
      for (k, v) in rules.items():
        if c in v:
          containers.add(k)
    if l == len(containers):
      break
  return len(containers)
  
def recur_rules(rules, target):
  res = 1
  for (k, v) in rules[target].items():
    res += recur_rules(rules, k) * v
  return res


@microbench
def part2(data):
  rules = parse_rules(data)
  target = "shiny gold"
  results = recur_rules(rules, target) -1 
  return results

