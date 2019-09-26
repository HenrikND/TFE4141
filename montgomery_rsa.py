def get_bit(bit_array,bit_location):
    return (bit_array>>bit_location)&0x1

def print_bit(number):
    print("0b{0:b}".format(number))

def print_hex(number):
    print("0x{0:x}".format(number))


def montgomery_product(a,b,n):
    S = 0
    for i in range(128):
            if get_bit(S+get_bit(a,i)*b,0) == 0:
                S = S + get_bit(a,i)*b
            else:
                S = S + get_bit(a,i)*b + n
            S = S >> 1
    if S >= n:
        return S-n
    else:
        return S



def modular_exponentiation(message,e,n):
    pre_def_P = pow(2,2*128,n)
