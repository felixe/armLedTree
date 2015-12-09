/******************************************************************************
*	helper.s
*	Felix Erlacher
*		
*	helper.s contains helping subroutinges for main.s 
******************************************************************************/
pinNum .req r0
pinFunc .req r1

/***************************************************
*       Enable necessary pins 
****************************************************/
.globl enablePins
enablePins:
	push {lr}
	enablePinsLoop:
		//gnd pins
		ldr pinNum,[r5],#4
		mov pinFunc, #1
		bl setGpioFunction
		//voltage pins
		ldr pinNum,[r7],#4
		mov pinFunc,#1
		bl setGpioFunction
		//just using gnd pins counter, 
		subs r6,r6,#1
		bne enablePinsLoop		
	//as by convention we have to take care of altered registers r5,r6,r7 
        //address of gndPin Array
      	ldr r5, =gndPins
        //set size of gndPin array
        mov r6, #5
	ldr r7, =voltPins


	pop {pc}


.unreq pinFunc
pinVal .req r1
.globl resetPins
/***************************************************
*       RESET everything subroutine
****************************************************/
resetPins:

	push {lr}
	resetPinsLoop:
		//gnd pins
		ldr pinNum,[r5],#4
		mov pinVal, #1
		bl setGpio
		//voltage pins
		ldr pinNum,[r7],#4
		mov pinVal,#0
		bl setGpio
		//just using gnd pins counter, 
		subs r6,r6,#1
		bne resetPinsLoop		

	//as by convention we have to take care of altered registers r5,r6,r7 
        //address of gndPin Array
      	ldr r5, =gndPins
        //set size of gndPin array
        mov r6, #5
	ldr r7, =voltPins	
	pop {pc}
