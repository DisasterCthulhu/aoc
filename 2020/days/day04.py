from lib import *


def datafile():
    return "input/04"


required_fields = [
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    # "cid", # optional
    "pid",
]


def process_passport(data):
    fields = " ".join(data).split()
    passport = {}
    for field in fields:
        (k, v) = field.split(":")
        passport[k] = v
    return passport


def get_passport(data):
    passport = []
    for line in data.splitlines():
        if line == "":
            yield process_passport(passport)
            passport = []
        passport.append(line)
    yield process_passport(passport)


def validate_fields(passport):
    for field in required_fields:
        if field not in passport:
            return False
    return True


@microbench
def part1(data):
    passports = []
    for passport in get_passport(data):
        passports.append(passport)
    return sum([validate_fields(passport) for passport in passports])


def validate_data(pp):
    byr = int(pp["byr"])
    if not (1920 <= byr <= 2002):
        return False
    iyr = int(pp["iyr"])
    if not (2010 <= iyr <= 2020):
        return False
    eyr = int(pp["eyr"])
    if not (2020 <= eyr <= 2030):
        return False
    (hgt, unit) = (pp["hgt"][0:-2], pp["hgt"][-2:])
    if unit not in ["cm", "in"]:
        return False
    hgt = int(hgt)
    if unit == "cm" and not (150 <= hgt <= 193):
        return False
    if unit == "in" and not (59 <= hgt <= 76):
        return False
    ecl = pp["ecl"]
    if ecl not in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]:
        return False
    if not re.match("^\#[0-9a-f]{6}$", pp["hcl"]):
        return False
    if not re.match("^\d{9}$", pp["pid"]):
        return False
    return True


@microbench
def part2(data):
    passports = []
    for passport in get_passport(data):
        passports.append(passport)
    passports = [pp for pp in passports if validate_fields(pp) and validate_data(pp)]

    return len(passports)
