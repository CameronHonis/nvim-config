import numpy as np


class ASDF:
    first_name: str
    last_name: str

    def __init__(self, first: str, last: str):
        self.first_name = first
        self.last_name = last


def apricot():
    c = 3
    print("apricot")
    asdf = ASDF("jimmy", "jones")
    print(asdf)
    return c


d = {
    'key': "value",
    'another_key': "another_value",
}

a = 1
b = 2
np.array([])
c = apricot()
print("a")
print("b")
