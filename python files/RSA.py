class montgomery_reduction:

    def __init__(self, n, e):
        pass

    def encrypt(self, M):
        # M^e mod n

        pass


    def mon_check(self, M):
        high_lvl_example = self.encrypt(M)
        built_in_python_function = pow(M,self.e,self.n) #built in function for cumputing known answer
        if high_lvl_example == built_in_python_function:
            print("function worked", high_lvl_example, built_in_python_function)
        else:
            print("function did not work!!", high_lvl_example, built_in_python_function)


    def calculate_r(self):
        r = 2
        n = self.n

        while r <= n:
            r = r * 2
        self.r = r
        return r


    def calculate_r_mod_n(self):
        r_mod_n = self.remainder(self.r, self.n)
        self.r_mod_n = r_mod_n

        r2_mod_n = self.remainder(self.r**2, self.n)
        self.r2_mod_n = r2_mod_n

        return r_mod_n, r2_mod_n

    def calculate_k(self):
        pass

    def remainder(self, number, divisor):
        while number >= divisor:
            number -= divisor
        return number

class RSA_keys():
    p = 7
    q = 17
    e = 23

    def __init__(self):
        self.n=self.p*self.q
        self.phi=(self.p-1)*(self.q-1)
        self.calculate_d()

    def calculate_d(self):
        j = 0
        while 1:
            j = j +1
            d = self.phi-j
            d=(d*self.e)

            remainder = d%self.phi

            if remainder == 1:
                self.d = self.phi-j
                return self.d


