/***************************0*************************************************
*	main.s
*	Felix Erlacher
*	
*	This code uses the raspberry PI model B to power a 5x5 LED Matrix.
*	GPIO pins 2,3,4,17,27 are used as GND pins. GPIO pins 14,15,18,23,24 are used as Voltage pins.
*	It uses routines in files bitMask2LED.s, gpioFunc.s and sysTimer.s
*	Code is in ARMv6 assembler.
***************************************************************************/
.section .init
//gndPins:	.word 2,3,4,17,27
//voltPins:	.word 14,15,18,23,24

//as by convention this is the entry point
.globl _start
_start:

b main
//important for compiling (see linker file)
.section .text
main:

bl enablePiPins
bl resetPiPins

////step through all LEDs
//mov r0, #1
//ldr r1,=400
//mov r3,#25
//stepThroughLoop:
//	bl bitMask2LED
//	mov r0,r0,lsl #1
//	subs r3,r3,#1
//	bne stepThroughLoop


//only outlines of pcb tree
ldr r0,=0x01FFC66F
ldr r1,=5000
bl bitMask2LED

//every second led:  =0xAAAAAAAA; 
ldr r0,=0xAAAAAAAA
bl bitMask2LED

//every second line on pcb tree
ldr r0,=0x01A07C39
bl bitMask2LED

//raute on pcb tree
ldr r0,=0x00262A6F
bl bitMask2LED

//triangle+dots on pcb tree
ldr r0,=0x0190B991
bl bitMask2LED

//alle aus
ldr r0,=0x00000000
bl bitMask2LED

//alle an
ldr r0,=0xFFFFFFFF
bl bitMask2LED

b main
