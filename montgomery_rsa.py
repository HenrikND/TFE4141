def get_bit(bit_array,bit_location):
    return (bit_array>>bit_location)&0x1

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
    mon_P = montgomery_product(pre_def_P,message,n)
    C = montgomery_product(pre_def_P,1,n)

    for i in range(127,-1,-1):
        C = montgomery_product(C,C,n)
        if get_bit(e,i):
            C = montgomery_product(mon_P,C,n)

    C = montgomery_product(1,C,n)
    return C


#main

#test fuctions
print("MODEXP",hex(modular_exponentiation(0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,
                            0x00000000000000000000000000010001,
                            0x819DC6B2574E12C3C8BC49CDD79555FD)))
print("MODEXP",hex(pow(0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,
                            0x00000000000000000000000000010001,
                            0x819DC6B2574E12C3C8BC49CDD79555FD)))