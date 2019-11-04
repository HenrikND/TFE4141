import numpy as np
from datetime import datetime
import random
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
    return C, S_mon, p_mod_n

#test fuctions
def generate_test_data(e):
    n = random.getrandbits(256)
    message = random.getrandbits(256)
    fasit, s_mon, p_mod_n = modular_exponentiation(message, e ,n)
    return fasit, s_mon, p_mod_n, message, n


def create_test_file(e,number_of_test_data):
    f = open("demofile2.txt", "w")

    for i in range(0, number_of_test_data):
        print("test run: {}".format(i))
        fasit, s_mon, p_mod_n, message, n = generate_test_data(e)
        f.write("fasit: {:x}, s_mon: {:x}, p_mod_n: {:x}, message: {:x}, n: {:x} \n".format(fasit, s_mon, p_mod_n, message, n))
    f.close()


create_test_file(0x10001,500)