def aritmeticaModular(a,b):
    residuo_val = 1
    residuo = 0
    for i in range(a):
        if residuo_val >= b:
            residuo_val = 0
        residuo = residuo_val 
        residuo_val = residuo_val + 1
    return residuo

a = 1681
b = 50


if __name__ == '__main__':
    print(f"--- Residuo: {aritmeticaModular(a,b)}")


