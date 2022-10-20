.global _start
_start:
	
mov r0, #8
mov r1, #8
mult_a_b:
    mov r2, r0
    while:
        cmp r1, #1
        BLE endWhile

        add r2, r2, r0
        sub r1, r1, #1
        B while
    endWhile:
        mov r10, #255 // Show result resultado
	
	
