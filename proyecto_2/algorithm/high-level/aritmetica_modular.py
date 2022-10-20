def aritmeticaModular(a,b): # a mod b
    residuo_val = 1
    residuo = 0
    for i in range(a):
        if residuo_val >= b:
            residuo_val = 0
        residuo = residuo_val 
        residuo_val = residuo_val + 1
    return residuo

# a = 7 | b = 3
def aritmeticaModular2(a,b): # a mod b | 7 mod 3
    residuo_val = 1
    residuo = 0 
    while a>0: # 7. | 6. | 5. | 4. | 3. | 2. | 1.
        if residuo_val >= b: # 1 >= 3. | 2 >= 3. | 3 >= 3. | 1 >= 3. | 2 >= 3. | 3 >= 3. | 1 >= 3.
            residuo_val = 0 

        residuo = residuo_val # 1. | 2. | 0. | 1. | 2. | 0. | 1.
        residuo_val = residuo_val + 1 # 2. | 3. | 1. | 2. | 3. | 1. | 2. 
        a = a - 1 # 6. | 5. | 4. | 3. | 2. | 1. | 0.
    return residuo


a = 168
b = 50


if __name__ == '__main__':
    print(f"--- Residuo: {aritmeticaModular2(a,b)}")




