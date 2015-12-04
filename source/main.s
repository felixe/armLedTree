/****************************************************************************
*	main.s
*	Felix Erlacher
*	
*	This program blinks all leds.

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
ldr r4, =500000

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
*	SET every LED on
****************************************************/
loop$:
pinVal .req r1

///////Set all GND pins:
//first gnd
mov pinNum,#2
mov pinVal,#0
bl SetGpio

mov pinNum,#3
mov pinVal,#0
bl SetGpio

mov pinNum,#4
mov pinVal,#0
bl SetGpio

mov pinNum,#17
mov pinVal,#0
bl SetGpio

mov pinNum,#27
mov pinVal,#0
bl SetGpio

//////set all V pins:
mov pinNum,#14
mov pinVal,#1
bl SetGpio

mov pinNum,#15
mov pinVal,#1
bl SetGpio

mov pinNum,#18
mov pinVal,#1
bl SetGpio

mov pinNum,#23
mov pinVal,#1
bl SetGpio

mov pinNum,#24
mov pinVal,#1
bl SetGpio
//WAIT
mov r0, r4
bl Wait
/***************************************************
*	start LOOP
*	SET every LED off
****************************************************/

///////Set all GND pins:
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

//////set all V pins:
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
//WAIT
mov r0, r4
bl Wait

/*
* Loop!
*/
b loop$
