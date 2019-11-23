import os
import math
import random
from random import randrange, getrandbits



def get_bit(bit_array,bit_location):
    #will return 1 if the bit in location is 1
    #and will return 0 if the bit is 0
    return (bit_array>>bit_location)&0x1


def montgomery_product(a,b,n):
    S = 0
    for i in range(256):
            if get_bit(S + get_bit(a,i)*b,0) == 0:
                S = S + get_bit(a,i)*b
            else:
                S = S + get_bit(a,i)*b + n
            S = S >> 1
    if S >= n:
        return S-n
    else:
        return S

def create_test_file_monpro(number_of_runs):
    f = open("../monpro_testvectors.txt", "w")
    print("begin")
    for i in range(0,number_of_runs):
        a = random.getrandbits(256)
        b = random.getrandbits(256)
        n = random.getrandbits(256)
        fasit = montgomery_product(a,b,n)
        f.write("{:0256b}{:0256b}{:0256b}{:0256b}\n".format(fasit,a,b,n))
    f.close()
    print("done")

create_test_file_monpro(100)