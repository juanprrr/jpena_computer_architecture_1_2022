.global _start
_start:
	
mov r0, #8 //a
mov r1, #8 //b
mult_a_b: //(r0&r2,r1)(a,b)
    mov r2, r0
    while:
        cmp r1, #1
        ble endWhile

        add r2, r2, r0
        sub r1, r1, #1
        B while
    endWhile:
        mov r10, #255 // Show result resultado
	


/*
// ----------  mult_a_b ----------
mov var1, #8 //a
mov var2, #8 //b
mult_a_b: //(var1&r2,var2)(a,b)
    mov result, var1
    while_mult:
        cmp var2, #1
        ble end_while_end

        add result, result, var1
        sub var2, var2, #1
        B while_mult
    end_while_end:
        add result, #0 //return
end_mult_a_b
mov final_mult, #255
// ----------  mult_a_b ----------
*/
