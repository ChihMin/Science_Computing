N = 444266014606582911577255360081280172978907874637194279031281180366057
def fast_power(a,n):
    # print "%s %s" % (a, n)
    result = 1
    value = a
    power = n
    while power > 0:
        if power % 2 == 1:
            result = result * value % N
        value = value * value % N
        power = power/2
    return result
    
c = 0
c_last = 2
for i in range(2, 10001):
    c = fast_power(c_last, i)
    c = c % N
    c_last = c
print c
