N = 862021547643631582396998212208722914288258644234791307950582916442747222039795609417741932278317121
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
               
def gcd(a, b):
    if a == 0:
        return b
    return gcd(b%a, a) 

for k in range(10000, 100000):
    c = 0
    c_last = 2
    for i in range(2, k+1):
	    c = fast_power(c_last, i)
	    c = c % N
	    c_last = c
    c = c - 1
    
    p = gcd(c, N)
    # print "%s %s" % (p, c)
    q = N / p
    if p * q == N:
        print "%s %s" % (p, q) 
        
