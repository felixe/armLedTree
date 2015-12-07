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

//as by convention this is the entry point
.globl _start
_start:
b main
.section .text
main:

//wait time  (microsecs) between rows
ldr r4, =100000

pinNum .req r0
pinVal .req r1

//use subroutine to enable used GPIO pins
bl enableLoop

//use subroutine to reset used GPIO pins to defined value
bl resetLoop

loop:
	//put first gnd low 
	mov pinNum,#2
	mov pinVal,#0
	bl SetGpio
	//loop through voltage pins and set them high (one at a time)
	bl voltLoop
	//turn first gnd high 
	mov pinNum,#2
        mov pinVal,#1
        bl SetGpio
	//...	
	mov pinNum,#3
	mov pinVal,#0
	bl SetGpio

	bl voltLoop

	mov pinNum,#3
        mov pinVal,#1
        bl SetGpio

	mov pinNum,#4
	mov pinVal,#0
	bl SetGpio

	bl voltLoop

	mov pinNum,#4
        mov pinVal,#1
        bl SetGpio

	mov pinNum,#17
	mov pinVal,#0
	bl SetGpio

	bl voltLoop

	mov pinNum,#17
        mov pinVal,#1
        bl SetGpio

	mov pinNum,#27
	mov pinVal,#0
	bl SetGpio

	bl voltLoop

	mov pinNum,#27
        mov pinVal,#1
        bl SetGpio

bl loop

/* exit syscall, will never be reached */
mov r7, #1 
swi #0
