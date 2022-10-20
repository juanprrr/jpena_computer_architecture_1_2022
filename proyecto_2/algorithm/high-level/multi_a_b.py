def mult_a_b(factor, n): # Multiplicar factor1 * factor2
    resultado = factor
    while n > 1:
        resultado = resultado + factor
        n = n - 1
    print(resultado)
    return resultado