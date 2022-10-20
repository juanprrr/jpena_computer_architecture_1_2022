from aritmetica_modular import aritmeticaModular
from multi_a_b import sumar_n_veces as mult_a_b


# m = c^d mod n

def desencriptado(c,d,n):
    c2 = c
    exponente_actual = 1
    potencia_and_rediduo = []

    # d = 200 y n = 50
    while not (exponente_actual >= d): # 1 | 2 | 4  | 8   | 16  | ... | 64   | 128 | 256 ya es mayor
        if c2 > n:              # 3 | 9 | 81 | 961 | 121 | ... | 1681 | 961 | 121
            residuo = aritmeticaModular(c2, n)  # Residuo entre 81/50 equivale a 81 mod 50 = 31 | 961 mod 50 = 11 | 121 mod 50 | ... | 1681 mod 50 | 961 mod 50 = 11 
            c2 = residuo # 31 | 11 | 21 | ... | 31 | 11 | 21

        #guardar c2 actual y saber cual es su exponente
        potencia_and_rediduo.append([c2, exponente_actual]) # 3 y 1 | 9 y 2 | 31 y 4 | 11 y 8 | 21 y 16 | 31 y 64 | 11 y 128

 

        # -------- Preparando potencia y dividendo de la siguiente iteracion. DEBE  de pasar la condicion para volver a iterar -----------
        c2 = mult_a_b(c2,c2) # c2^c2 -> Solo se hace la aplicacion de la potencia cuando esta vale 2: c2^2 = c2*c2 ||||| 9 | 9*9 = 81 | 31*31 = 961 | 11*11 = 121 | 21*21=441 | ... | 31*31=961 | 11*11
        exponente_actual = mult_a_b(exponente_actual,2) #exponente_actual*2                                        ||||| 2 | 4        | 8           | 16          | 32        | ... | 128       | 256

    if exponente_actual > d: # Si el exponente_actual es = a d, entonces no hago el if y calculo directamente el valor de la aritmetica modular
        # Calcular binario de d y ver cuales bits estan encendidos y guardar el valor de dicho bit -> 200 = 11001000 => 128, 64 y 8 son los valores que deben de guardarse.
        # lista = binariosValues(d)
        # Obtener cuales valores de los c2 calculados arriba (save en linea 19) que tienen como potencia los valores de la descomposicion anterior guardada en lista.
        # Multiplicar dichos valores de c2 (que seran pequennos):
            # (resultado de los c2's que tienen como potencia los valores de la descomposicion en bits d)(en decimal) -> ()()() mod n => x mod n => c mod n
        # Notese que en este punto el valor de c2 no tiene exponente mayor a 1.
        print()
    # Finalmente aplicarles el modulo de n pues sabemos que aca el exponente de c es de 1.
    residuo = aritmeticaModular(c2, n)

    m = residuo
    return m

def binarioValues(decimalNum):
    # Ver la posicion n de los bits que estan en uno.
    # Multiplicar el numero dos n veces el cual daria de resultado'y'.
    # Guardar 'y' en lista
    # return lista.
    return



# ----------- Funtion call ------------ 
c = 3
d = 200
n = 50

msj_des = desencriptado(c,d,n)
print(f"Mensaje desencriptado {msj_des}")