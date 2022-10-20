.global _start
_start:
	
	// a mod b => r0 mod r1
	mov r0, #168 // a
	mov r1, #50 // b
	
arimetica_modular:
	mov r2, #1 // residuo_val
	mov r3, #0 // residuo
	
while:	
	cmp r0, #0
	BLE end_while
if:	
	cmp r2, r1
	BLT end_if
	
	mov r2, #0
end_if:
	mov r3, r2
	add r2, #1
	sub r0, #1
	b while
end_while:
	mov r4, #255
	
	
	