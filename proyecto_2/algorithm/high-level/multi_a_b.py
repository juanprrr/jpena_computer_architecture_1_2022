from unittest import result
from symbol import factor


def mult_a_b(factor, n): # Multiplicar factor1 * factor2
    resultado = factor
    while n > 1:
        resultado = resultado + factor
        n = n - 1
    print(resultado)
    return resultado


#mov factor, #a
#mov n, #b
#mult_a_b:
#    mov resultado, factor
#    while:
#        cmp n, #1
#        BLE endWhile

#        add resultado, resultado, factor
#        sub n, n, #1
#        B while
#    endWhile:
#        mov r1, #255 // Show result resultado

#mov r0, #a
#mov r1, #b
#mult_a_b:
#    mov r2, r0
#    while:
#        cmp r1, #1
#        BLE endWhile

#        add r2, r2, r0
#        sub r1, r1, #1
#        B while
#    endWhile:
#        mov r10, #255 // Show result resultado
