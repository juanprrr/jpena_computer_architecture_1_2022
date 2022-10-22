

mov r0, 0x100
mov r1, 0

cal_binario:
    while:
        cmp dividendo, 0
        be end_while 
        mov r2, end_cal_reciduo
        st r2, r1(r0)

        mov dividendo, cal_cociente
        add r1, #4
    end_while:
    mov r5, #255
end_cal_binario:
    mov r5, #255



