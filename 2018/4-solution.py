#!/usr/bin/env python
import re, operator

class Event(object):
    def __init__(self, event):
        pattern = re.compile(r'\[(?P<ymdh>[^:]*):(?P<minute>\d\d)\] (?P<type>[^$]+)$')
        m = pattern.match(line)
        self.minute = int(m.group('minute'))
        self.type = m.group('type')

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return "{}: {}".format(self.minute, self.type)


class Guard(object):
    # [1518-03-02 00:02] Guard #3079 begins shift
    # [1518-03-02 00:08] falls asleep
    # [1518-03-02 00:48] wakes up
    # [1518-03-02 00:51] falls asleep
    # [1518-03-02 00:52] wakes up

    def __init__(self, line):
        pattern = re.compile(r'\[(?P<ymdh>[^:]*):(?P<start>\d\d)\] Guard #(?P<id>\d+) begins shift')
        m = pattern.match(line)
        self.id = m.group('id')
        self.events = []
        self.add_event(line)
        self.sleeping = dict.fromkeys(range(0, 60), 0)

    def add_event(self, line):
        self.events.append(Event(line))

    def process_events(self):
        start = None
        for event in self.events:
            if event.type == "falls asleep":
                start = event.minute
            if event.type == "wakes up":
                for t in range(start, event.minute):
                    self.sleeping[t] = self.sleeping[t] + 1
                start = None


    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return "<Guard: #{}: {}>".format(self.id, self.events)

lines = [line.rstrip("\n") for line in open('4-input.txt')]
lines.sort()
begins_shift = re.compile(r'\[(?P<ymdh>[^:]*):(?P<start>\d\d)\] Guard #(?P<id>\d+) begins shift')
guards = {}
for line in lines:
    if "begins shift" in line:
        m = begins_shift.match(line)
        gid = m.group('id')
        if gid in guards:
            guard = guards[gid]
        else:
            guard = guards[gid] = Guard(line)
    else:
        guard.add_event(line)

guard_maxes = {}
for guard in guards.values():
    guard.process_events()
    guard_maxes[guard.id] = sum(guard.sleeping.values())

#most total minutes asleep
top_gid = max(guard_maxes.items(), key=operator.itemgetter(1))[0]

#most likely time to be asleep
usually_asleep = max(guards[top_gid].sleeping.items(), key=operator.itemgetter(1)) # min: count
print("4-A: Most sleepy guard")
print(top_gid, usually_asleep)
print("Ans:", int(top_gid) * usually_asleep[0])


guard_maxes = {}
for guard in guards.values():
    guard.process_events()
    guard_maxes[guard.id] = max(guard.sleeping.values())

#most total minutes asleep
top_gid = max(guard_maxes.items(), key=operator.itemgetter(1))[0]

#most likely time to be asleep
usually_asleep = max(guards[top_gid].sleeping.items(), key=operator.itemgetter(1)) # min: count
print("4-B: Guard with the most regular sleep schedule")
print(top_gid, usually_asleep)
print("Ans:", int(top_gid) * usually_asleep[0])
