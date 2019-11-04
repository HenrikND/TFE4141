import numpy as np
from datetime import datetime
# python version of vhdl code
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


print(np.random.randint(low=1, high=100, size=4))
#test fuctions
