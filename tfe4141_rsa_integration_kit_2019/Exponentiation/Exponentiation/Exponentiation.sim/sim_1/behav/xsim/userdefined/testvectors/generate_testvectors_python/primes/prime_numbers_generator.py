import os
import math
import random
from random import randrange, getrandbits

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

def generate_prime_number(length=128):
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

def generate_list_of_prime_numbers(number_of_primes):
    #create new file, that does not exist
    path = "./prime_numbers.txt"
    attemp_number = 0
    while os.path.exists(path):
        attemp_number += 1
        path = "./prime_numbers_{}.txt".format(attemp_number)
        print("file write attempt: {}".format(attemp_number))

    #open file
    prime_numbers_file = open(path,"w")

    #write overhead of file
    prime_numbers_file.write("{}\n".format(number_of_primes))

    #write prime numbers to file
    for i in range(number_of_primes):
        prime_numbers_file.write("{}\n".format(generate_prime_number()))
        print("prime found = {}".format(i))

    #close file
    prime_numbers_file.close()

generate_list_of_prime_numbers(1000)