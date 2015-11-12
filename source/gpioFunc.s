/******************************************************************************
*	gpioFunc.s
*	Felix Erlacher
*	based on Alex Chadwicks "baking Pi" code (http://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/index.html)
*		
*	contains routines for manipulation of the raspberry GPIO ports used in main.
*	Adresses are specific to the bcm2835 SoC used in raspberry model B.
******************************************************************************/

/*
* We are trying to comply with EABI. At least in register usage (r0-r3 for passing
* parameters, preserve values in registers r4-r8,r10-r11,sp between calls, 
* return values in r0 (and possibly r1)). 
*/

/*
* GetGpioAddress returns the base address of the GPIO region as a physical address
* in register r0.
*/
.globl GetGpioAddress
GetGpioAddress: 
	ldr r0,=0x20200000
	mov pc,lr

/*
* SetGpioFunction sets the function of the GPIO register addressed by r0 to the
* low  3 bits of r1.
*/
.globl SetGpioFunction
SetGpioFunction:
	//for readability we are creating aliases
    	pinNum .req r0
    	pinFunc .req r1
	cmp pinNum,#53
	cmpls pinFunc,#7
	movhi pc,lr
	//until now we have checked the validity of the input registers

	//push lr (address to return to after function is finished) on stack because we overwrite it through a second function call below
	push {lr}
	
	//we need r0, so we have to move its contents (at the moment the gpio address) to r2
	mov r2,pinNum
	.unreq pinNum
	pinNum .req r2

	//and now we "call" the function
	bl GetGpioAddress
	gpioAddr .req r0

	//calculate the block the given gpio pin resides in
	functionLoop$:
		cmp pinNum,#9
		subhi pinNum,#10
		addhi gpioAddr,#4
		bhi functionLoop$

		//change affectetd 3 bits and do crazy stuff to leave rest of the pins as they are
		add pinNum, pinNum,lsl #1
		lsl pinFunc,pinNum

		mask .req r3
		mov mask,#7				/* r3 = 111 in binary */
		lsl mask,pinNum				/* r3 = 11100..00 where the 111 is in the same position as the function in r1 */
		.unreq pinNum

		mvn mask,mask				/* r3 = 11..1100011..11 where the 000 is in the same poisiont as the function in r1 */
		oldFunc .req r2
		ldr oldFunc,[gpioAddr]			/* r2 = existing code */
		and oldFunc,mask			/* r2 = existing code with bits for this pin all 0 */
		.unreq mask
	
		orr pinFunc,oldFunc			/* r1 = existing code with correct bits set */
		.unreq oldFunc

		str pinFunc,[gpioAddr]
		.unreq pinFunc
		.unreq gpioAddr
		pop {pc}

/*
* SetGpio sets the GPIO pin addressed by register r0 high if r1 != 0 and low otherwise. 
*/
.globl SetGpio
SetGpio:	
	pinNum .req r0
	pinVal .req r1

	cmp pinNum,#53
	movhi pc,lr
	push {lr}
	mov r2,pinNum	
    	.unreq pinNum	
    	pinNum .req r2
	//now validity checks are finished
	bl GetGpioAddress
    	gpioAddr .req r0
	
	//change gpio address to corresponding pinBank (+4bytes for upper 22 pins, +0 for lower 32)
	pinBank .req r3
	lsr pinBank,pinNum,#5
	lsl pinBank,#2
	add gpioAddr,pinBank
	.unreq pinBank

	//calculate bit set to turn pin off or on (e.g. to turn bit 40 on, the 8th bit is set to 1 because 40mod32=8)
	and pinNum,#31
	bitSet .req r3
	mov bitSet,#1
	lsl bitSet,pinNum
	.unreq pinNum

	//check if on or off is wished and store bitSet at 40(off) or 28(on)	
	teq pinVal,#0
	.unreq pinVal
	streq bitSet,[gpioAddr,#40]
	strne bitSet,[gpioAddr,#28]
	.unreq bitSet
	.unreq gpioAddr
	pop {pc}
