m = 0x8888888899999999aaaaaaaabbbbbbbbccccccccddddddddeeeeeeeeffffffff#0x0000000011111111222222223333333344444444555555556666666677777777
e = 0x0000000000000000000000000000000000000000000000000000000000010001
n = 0x99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d







bit_length_e = 256

def get_bit(bit_array,bit_location):
    #will return 1 if the bit in location is 1
    #and will return 0 if the bit is 0
    return (bit_array>>bit_location)&0x1

def montgomery_product(a,b,n):
    S = 0
    for i in range(bit_length_e):
            if get_bit(S + get_bit(a,i)*b,0) == 0:
                S = S + get_bit(a,i)*b
            else:
                S = S + get_bit(a,i)*b + n
            S = S >> 1
    if S >= n:
        return S-n
    else:
        return S

def modular_exponentiation(message,e,n):
    p_mod_n = pow(2,2*bit_length_e,n) # will be predefined since e and n is constant(the keys)
    S_mon = montgomery_product(p_mod_n,message,n)
    C = montgomery_product(1,p_mod_n,n) #prefined

    for i in range(bit_length_e-1,-1,-1):
        C = montgomery_product(C,C,n)
        if get_bit(e,i):
            C = montgomery_product(S_mon,C,n)
    C = montgomery_product(1,C,n)
    return C

p_mod_n = pow(2,2*bit_length_e,n)
C = montgomery_product(1,p_mod_n,n)
print(p_mod_n)
print(C)
print("")
print(pow(2,2*256,n))
print(p_mod_n%n)
#print(modular_exponentiation(m,e,n))