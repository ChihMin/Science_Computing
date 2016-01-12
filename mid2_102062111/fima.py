
def fima(a ,p):
    count = 0
    cur = 1
    n = -1
    for i in range(1, p):
        count = count + 1
        cur = (cur * a) % p 
        if (cur == 1):
            n = count
            print "n = %s, p-1 = %s" % (n, p-1)
            break
    return n

def check_correct(p, n):
    if (p - 1) % n != 0:
        print "Theory is not correct"
    else:
        print "Theroy is correct"

p = 1279

a = 123 # First a
b = 456 # Second a
c = 789 # Third a

check_correct(p, fima(a,p))
check_correct(p, fima(b,p))
check_correct(p, fima(c,p))

