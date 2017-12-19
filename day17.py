def spinner(d, t):
    a = [0]
    p = 1
    
    for i in range(t-1):
        if (i == 0):
            next
        p = (p + d) % len(a) + 1
        a = a[:p] + [i + 1] + a[p:]
        
    return a

def spinnerB(d, t):
    
    a = -1
    leng = 1
    p = 1

    for i in range(t-1):
        if (i == 0):
            next
        if p == 1:
            a = i
        p = (p + d) % leng + 1
        
        leng += 1
    return a

def after(a, num):
    for i in range(len(a)):
        if a[i] == num:
            return a[i+1]
    return -1

def part_a():
    
    a = spinner(376, int(2018))
    x = after(a, 2017)

    return x # 777

def part_b():
    a = spinnerB(376, int(5e7))

    # 442595 too low
    return a

ans_a = part_a()
assert (ans_a == 777)
print("part a: " + str(ans_a))

ans_b = part_b()
assert (ans_b == 39289581)
print("part b: " + str(ans_b))