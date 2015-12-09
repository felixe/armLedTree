/****************************************************************************
*	main.s
*	Felix Erlacher
*	
*	This code uses the raspberry PI model B to power a 5x5 LED Matrix.
*	It steps through all leds one after another.
*	GPIO pins 2,3,4,17,27 are used as GND pins. GPIO pins 14,15,18,23,24 are used as Voltage pins.
*	It uses routines in files helper.s gpioFunc.s and sysTimer.s
*	Code is in ARMv6 assembler.
***************************************************************************/
//this tells assembler to start at this point (and not at some other point in some other file)
.section .init

.globl gndPins
gndPins:	.word 2,3,4,17,27
.globl voltPins
voltPins:	.word 14,15,18,23,24

//as by convention this is the entry point
.globl _start
_start:
b main
.section .text
main:
//address of gndPin Array
ldr r5, =gndPins 
//set size of gndPin array
mov r6, #5
//address of gndPin Array
ldr r7, =voltPins 
//set size of gndPin array
mov r8, #5

//wait time  (microsecs) between rows
ldr r4, =50000

//use subroutine to enable necessary GPIO pins
bl enablePins
//use subroutine to reset GPIO pins to defined value
bl resetLoop

pinNum .req r0
pinVal .req r1
mainLoop:
	//address of gndPin Array
	ldr r5, =gndPins 
	//set size of gndPin array
	mov r6, #5
	gndLoop:
		//put gnd low 
		ldr pinNum,[r5]
		mov pinVal, #0
		bl setGpio
	
		//loop through voltage pins and set them high (one at a time)
		bl voltLoop
		
		//turn gnd high. we have to load pin number again because r0 is not preserved throughout calls 
		ldr pinNum,[r5],#4 //r5++4
		mov pinVal,#1
		bl setGpio
		//repeat for rest of gnd pins
		subs r6,r6,#1
		bne gndLoop
	b mainLoop
voltLoop:   
	//before branching again we have to save link register because it might get overwritten in subroutine
	push {lr}
	ldr r7, =voltPins
	mov r8, #5
	innerVoltLoop:
	        ldr pinNum,[r7]
	        mov pinVal,#1
     	        bl setGpio
	
	        //WAIT
	        mov r0, r4
	        bl Wait
	
	        ldr pinNum,[r7],#4
	        mov pinVal,#0
	        bl setGpio
		
		subs r8,r8,#1
		bne innerVoltLoop 
        //and now we pop back link register address from stack into the program counter
        pop {pc}

/* exit syscall, will never be reached */
mov r7, #1 
swi #0

//not enforced, but nice to have:
.end
