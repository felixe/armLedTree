/******************************************************************************
*	sysTimer.s
*	Felix Erlacher
*		
*	sysTimer.s contains code for system timer
* 	As the system timer simply runs at 1MHz and continuously counts, we can deduce the time by counting the diff between to readings.
******************************************************************************/
.globl wait
wait:
	stmfd sp!, {r0-r12,lr}

	ldr r3, =0x20003000
	ldr r2, [r3, #4]
sleep:
	ldr r1, [r3, #4]
	sub r1, r1, r2
	cmp r1, r0
	bls sleep

	ldmfd sp!, {r0-r12,pc}
