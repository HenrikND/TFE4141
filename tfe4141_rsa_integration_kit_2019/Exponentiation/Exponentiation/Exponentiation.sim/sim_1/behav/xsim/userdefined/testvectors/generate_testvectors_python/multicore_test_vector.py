import os
import math
import random
from random import randrange, getrandbits

def get_prime():
        path = "./primes/prime_numbers_2.txt"
        prime_numbers_file = open(path,"r")
        number_of_primes = prime_numbers_file.readline()
        prime_location = random.randint(1,int(number_of_primes))
        for i in range(0, prime_location):
            prime = prime_numbers_file.readline()
        return prime


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


def generate_test_vectors(number_of_test_vectors):
    print("begin")
    #open files
    messages_file = open("../multicore_testvectors.txt","w")
    fasit_file = open("../multicore_fasitvectors.txt","w")
    #set keys
    p = int(get_prime())
    q = int(get_prime())
    n = p*q
    phi = (p-1)*(q-1)
    e = random.getrandbits(256)
    while math.gcd(e,phi) != 1 or e-phi > 0 :
        e = random.getrandbits(256)
        while e-phi > 0:
            e -= random.randint(0, e-phi)
    p_mod_n = pow(2,2*256,n)
    C_begin = montgomery_product(1,p_mod_n,n)
    #write keys to file
    messages_file.write("{:0256b}{:0256b}{:0256b}{:0256b}\n".format(p_mod_n, C_begin,n,e))
    #generate messages
    for i in range(0, number_of_test_vectors):
        message = random.getrandbits(256)
        fasit = modular_exponentiation(message, e, n)
        #write message to file
        messages_file.write("{:0256b}\n".format(message))
        #write fasit to file
        fasit_file.write("{:0256b}\n".format(fasit))
        print("current message {}".format(i))
    #close files
    messages_file.close()
    fasit_file.close()
    print("done")


generate_test_vectors(100)