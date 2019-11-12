import math
import random
from random import randrange, getrandbits

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
        print("mon: {:x}".format(S-n))
        return S-n
    else:
        print("mon: {:x}".format(S))
        return S

def modular_exponentiation(message,e,n):
    p_mod_n = pow(2,2*bit_length_e,n) # will be predefined since e and n is constant(the keys)
    S_mon = montgomery_product(p_mod_n,message,n)
    C = montgomery_product(1,p_mod_n,n) #prefined
    C_begin = montgomery_product(1,p_mod_n,n)
    print("C: {:x}".format(C))
    for i in range(bit_length_e-1,-1,-1):
        C = montgomery_product(C,C,n)
        if get_bit(e,i):
            C = montgomery_product(S_mon,C,n)
    C = montgomery_product(1,C,n)
    return C,  p_mod_n, C_begin

#test fuctions
def generate_test_data(e, p, q):
    n = random.getrandbits(256)
    message = random.getrandbits(256)
    fasit, p_mod_n, C_begin = modular_exponentiation(message, e ,n)
    return fasit, p_mod_n, message, n, C_begin







def is_prime(n, k=128):
    """ Test if a number is prime
        Args:
            n -- int -- the number to test
            k -- int -- the number of tests to do
        return True if n is prime
    """
    # Test if n is not even.
    # But care, 2 is prime !
    if n == 2 or n == 3:
        return True
    if n <= 1 or n % 2 == 0:
        return False
    # find r and s
    s = 0
    r = n - 1
    while r & 1 == 0:
        s += 1
        r //= 2
    # do k tests
    for _ in range(k):
        a = randrange(2, n - 1)
        x = pow(a, r, n)
        if x != 1 and x != n - 1:
            j = 1
            while j < s and x != n - 1:
                x = pow(x, 2, n)
                if x == 1:
                    return False
                j += 1
            if x != n - 1:
                return False
    return True
def generate_prime_candidate(length):
    """ Generate an odd integer randomly
        Args:
            length -- int -- the length of the number to generate, in bits
        return a integer
    """
    # generate random bits
    p = getrandbits(length)
    # apply a mask to set MSB and LSB to 1
    p |= (1 << length - 1) | 1
    return p
def generate_prime_number(length=256):
    """ Generate a prime
        Args:
            length -- int -- length of the prime to generate, in          bits
        return a prime
    """
    p = 4
    # keep generating while the primality test fail
    while not is_prime(p, 128):
        p = generate_prime_candidate(length)
    return p
#print(generate_prime_number())



def create_test_file(number_of_test_data):
    f = open("modexp_testvectors.txt", "w")
    primes = [generate_prime_number() for i in range(0, 20)]

    for i in range(0, number_of_test_data):
        print("test run: {}".format(i))
        p = random.choice(primes)
        q = random.choice(primes)
        phi = (p-1)*(q-1)
        e = random.getrandbits(256)
        while math.gcd(e,phi) != 1 or e-phi > 0 :
            e = random.getrandbits(256)
            while e-phi > 0:
                e -= random.randint(0, e-phi)

        fasit, p_mod_n, message, n, C_begin = generate_test_data(e,p,q)
        f.write("{:0256b}{:0256b}{:0256b}{:0256b}{:0256b}{:0256b}\n".format(fasit,p_mod_n,message,n, C_begin,e))
    f.close()


create_test_file(2)

def create_test_file_monpro(number_of_runs):
    f = open("monpro_test_vector.txt", "w")
    print("begin")
    for i in range(0,number_of_runs):
        a = random.getrandbits(256)
        b = random.getrandbits(256)
        n = random.getrandbits(256)

        fasit = montgomery_product(a,b,n)
        #print("fasit: {:064x}".format(fasit))
        f.write("{:0256b}{:0256b}{:0256b}{:0256b}\n".format(fasit,a,b,n))
    f.close()
    print("done")

#create_test_file_monpro(100)
