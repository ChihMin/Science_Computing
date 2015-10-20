#!/usr/bin/env python

from sage.all import *
x = 100
cnt = 0
for i in xrange(1, x):
    if gcd(i, x) == 1:
        print i
        cnt = cnt + 1

    
