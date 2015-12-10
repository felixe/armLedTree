/****************************************************************************
*	main.s
*	Felix Erlacher
*	
*	This code uses the raspberry PI model B to power a 5x5 LED Matrix.
*	The Matrix should show something resembling a Christmas Tree.
*	GPIO pins 2,3,4,17,27 are used as GND pins. GPIO pins 14,15,18,23,24 are used as Voltage pins.
*	It uses routines in files gpioFunc.s and sysTimer.s
*	Code is in ARMv6 assembler.
***************************************************************************/
.section .init
//Arrays with used pins
.globl gndPins
gndPins:	.word 2,3,4,17,27
.globl voltPins
voltPins:	.word 14,15,18,23,24

//as by convention this is the entry point
.globl _start
_start:

b main

//important for compiling (see makefile)
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
ldr r4, =10

pinNum .req r0
pinVal .req r1
//use subroutine to enable necessary GPIO pins
bl enablePins

loop$:
	//use subroutine to reset GPIO pins to defined value
	bl resetPins
	/***************************************************
	* FIRST ROW
	****************************************************/
	//first gnd
	mov pinNum,#2
	mov pinVal,#0
	bl setGpio
	
	//first V
	mov pinNum,#18
	mov pinVal,#1
	bl setGpio
	
	//WAIT
	mov r0, r4
	bl wait
	
	/***************************
	*second ROW
	***************************/
	////////turn unused old pins viceversa
	//gnd
	mov pinNum,#2
	//turn pin on
	mov pinVal,#1
	bl setGpio
	
	///////turn second row on
	// gnd
	mov pinNum,#3
	mov pinVal,#0
	bl setGpio
	
	// V
	mov pinNum,#14
	mov pinVal,#1
	bl setGpio
	
	mov pinNum,#15
	mov pinVal,#1
	bl setGpio
	
	//pin 18 already high
	
	mov pinNum,#23
	mov pinVal,#1
	bl setGpio
	
	mov pinNum,#24
	mov pinVal,#1
	bl setGpio
	
	//WAIT microsecs
	mov r0, r4
	bl wait
	
	/***************************
	*third ROW
	***************************/
	////////turn unused old pins viceversa
	//gnd
	mov pinNum,#3
	mov pinVal,#1
	bl setGpio
	
	// V
	mov pinNum,#14
	mov pinVal,#0
	bl setGpio
	
	mov pinNum,#24
	mov pinVal,#0
	bl setGpio
	
	/////turn necessary pins on
	//only gnd necesary, 15,18,23 pins already high
	mov pinNum,#4
	mov pinVal,#0
	bl setGpio
	
	//WAIT
	mov r0, r4
	bl wait
	
	/***************************
	*fourth ROW
	***************************/
	////////turn unused old pins viceversa
	mov pinNum,#4
	mov pinVal,#1
	bl setGpio
	
	// V
	mov pinNum,#15
	mov pinVal,#0
	bl setGpio
	
	mov pinNum,#23
	mov pinVal,#0
	bl setGpio
	
	/////turn necessary pins on
	//only gnd necesary, 18 already high
	mov pinNum,#17
	mov pinVal,#0
	bl setGpio
	
	//WAIT
	mov r0, r4
	bl wait
	
	/***************************
	*fifth ROW
	***************************/
	////////turn unused old pins viceversa
	mov pinNum,#17
	mov pinVal,#1
	bl setGpio
	
	/////turn necessary pins on
	mov pinNum,#27
	mov pinVal,#0
	bl setGpio
	
	//WAIT
	mov r0, r4
	bl wait
	
	// Loop forever!
	b loop$
