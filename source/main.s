/****************************************************************************
*	main.s
*	Felix Erlacher
*	based on Alex Chadwicks "baking Pi" code (http://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/index.html)
*	
*	This code uses the raspberry PI model B to power a 5x5 LED Matrix.
*	The Matrix should show something resembling a Christmas Tree.
*	GPIO pins 2,3,4,17,27 are used as GND pins. GPIO pins 14,15,18,23,24 are used as Voltage pins.
*	It uses routines in files gpioFunc.s and sysTimer.s
*	Code is in ARMv6 assembler.
***************************************************************************/

.section .init
//as by convention this is the entry point
.globl _start
_start:

b main

//important for compiling (see makefile)
.section .text

main:

//setting stack pointer to default load address
mov sp,#0x8000

//wait time  (microsecs) between rows
ldr r4, =10

/***************************************************
*	Enable necessary pins 
****************************************************/

//////// GROUND PINS (inside pin row on raspberry)
pinNum .req r0
pinFunc .req r1
mov pinNum,#2
mov pinFunc,#1
bl SetGpioFunction

mov pinNum,#3
mov pinFunc,#1
bl SetGpioFunction

mov pinNum,#4
mov pinFunc,#1
bl SetGpioFunction

mov pinNum,#17
mov pinFunc,#1
bl SetGpioFunction

mov pinNum,#27
mov pinFunc,#1
bl SetGpioFunction

/////// VOLTAGE PINS (outside pin row on raspberry)
mov pinNum,#14
mov pinFunc,#1
bl SetGpioFunction

mov pinNum,#15
mov pinFunc,#1
bl SetGpioFunction

mov pinNum,#18
mov pinFunc,#1
bl SetGpioFunction

mov pinNum,#23
mov pinFunc,#1
bl SetGpioFunction

mov pinNum,#24
mov pinFunc,#1
bl SetGpioFunction

.unreq pinFunc
/***************************************************
*	start LOOP
*	
*	RESET everything, not fully necessary but helps
*
*
****************************************************/
loop$:
pinVal .req r1

///////Set all GND pins high:
//first gnd
mov pinNum,#2
mov pinVal,#1
bl SetGpio

mov pinNum,#3
mov pinVal,#1
bl SetGpio

mov pinNum,#4
mov pinVal,#1
bl SetGpio

mov pinNum,#17
mov pinVal,#1
bl SetGpio

mov pinNum,#27
mov pinVal,#1
bl SetGpio

//////set all V pins low:
mov pinNum,#14
mov pinVal,#0
bl SetGpio

mov pinNum,#15
mov pinVal,#0
bl SetGpio

mov pinNum,#18
mov pinVal,#0
bl SetGpio

mov pinNum,#23
mov pinVal,#0
bl SetGpio

mov pinNum,#24
mov pinVal,#0
bl SetGpio

/***************************************************
* FIRST ROW
****************************************************/
//first gnd
mov pinNum,#2
mov pinVal,#0
bl SetGpio

//first V
mov pinNum,#18
mov pinVal,#1
bl SetGpio

//WAIT
mov r0, r4
bl Wait

/***************************
*second ROW
***************************/
////////turn unused old pins viceversa
//gnd
mov pinNum,#2
//turn pin on
mov pinVal,#1
bl SetGpio

///////turn second row on
// gnd
mov pinNum,#3
mov pinVal,#0
bl SetGpio

// V
mov pinNum,#14
mov pinVal,#1
bl SetGpio

mov pinNum,#15
mov pinVal,#1
bl SetGpio

//pin 18 already high

mov pinNum,#23
mov pinVal,#1
bl SetGpio

mov pinNum,#24
mov pinVal,#1
bl SetGpio

//WAIT microsecs
mov r0, r4
bl Wait

/***************************
*third ROW
***************************/
////////turn unused old pins viceversa
//gnd
mov pinNum,#3
mov pinVal,#1
bl SetGpio

// V
mov pinNum,#14
mov pinVal,#0
bl SetGpio

mov pinNum,#24
mov pinVal,#0
bl SetGpio

/////turn necessary pins on
//only gnd necesary, 15,18,23 pins already high
mov pinNum,#4
mov pinVal,#0
bl SetGpio

//WAIT
mov r0, r4
bl Wait

/***************************
*fourth ROW
***************************/
////////turn unused old pins viceversa
mov pinNum,#4
mov pinVal,#1
bl SetGpio

// V
mov pinNum,#15
mov pinVal,#0
bl SetGpio

mov pinNum,#23
mov pinVal,#0
bl SetGpio

/////turn necessary pins on
//only gnd necesary, 18 already high
mov pinNum,#17
mov pinVal,#0
bl SetGpio

//WAIT
mov r0, r4
bl Wait

/***************************
*fifth ROW
***************************/
////////turn unused old pins viceversa
mov pinNum,#17
mov pinVal,#1
bl SetGpio

/////turn necessary pins on
mov pinNum,#27
mov pinVal,#0
bl SetGpio
.unreq pinNum
.unreq pinVal

//WAIT
mov r0, r4
bl Wait

/*
* Loop!
*/
b loop$
