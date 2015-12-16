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

ldr r0,=0x1FFC66F0
ldr r1,=5000
bl bitMask2LED

//every second led:  =0xAAAAAAAA; 
ldr r0,=0xAAAAAAAA
ldr r1,=5000
bl bitMask2LED
