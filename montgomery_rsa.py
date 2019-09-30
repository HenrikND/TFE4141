bit_length_e = 256

def get_bit(bit_array,bit_location):
    return (bit_array>>bit_location)&0x1

def montgomery_product(a,b,n):
    S = 0
    for i in range(bit_length_e):
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
    pre_def_P = pow(2,2*bit_length_e,n)
    mon_P = montgomery_product(pre_def_P,message,n)
    C = montgomery_product(pre_def_P,1,n)

    for i in range(bit_length_e-1,-1,-1):
        C = montgomery_product(C,C,n)
        if get_bit(e,i):
            C = montgomery_product(mon_P,C,n)
    C = montgomery_product(1,C,n)
    return C


#main

#test fuctions
print("modular exponentiation:  ",(modular_exponentiation(19,
                                          0x5,
                                          0x77)))
print("built in python function:",(pow(19,
                       0x5,
                       0x77)))