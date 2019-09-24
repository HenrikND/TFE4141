class montgomery:
    p = 7
    q = 17
    e = 5
    d = 77
    def __init__(self):
        self.n=self.p*self.q
        self.phi=(self.p-1)*(self.q-1)

    def encrypt(self, M):
        # M^e mod n
        
        pass