.global _start
_start:
	
mov r0, #14 //r0 | It is given
mov r1, #2   //
cal_cociente: // cal_cociente(r0,r1)
    mov r2, #0 //cociente
    mov r3, #2 // div_x_n
	mov r4, #0

    while_cociente:
        cmp r0, r3
        ble end_while_cociente

        add r2, r2, #1 // r2 +=1
        // ----------  mult_a_b ----------
        add  r4, #1 //a
        mov  r5, r1 //b
        mult_a_b: //( r4&r2, r5)(a,b)
            mov  r3,  r4
            while_mult:
                cmp  r5, #1
                ble end_while_end

                add  r3,  r3,  r4
                sub  r5,  r5, #1
                B while_mult
            end_while_end:
                add  r3, #0 //return
        end_mult_a_b:
        mov r6, #255
        // ----------  mult_a_b ----------

        b while_cociente
    end_while_cociente:
        add r2, #0 //return r2
end_cal_cociente:
        mov r7, #255
	
