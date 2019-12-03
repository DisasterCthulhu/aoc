#!/bin/sh
qalc `sed -e ':x {N;s/\n//g; bx}' 1-input.txt`
