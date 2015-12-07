/******************************************************************************
*	helper.s
*	Felix Erlacher
*		
*	helper.s contains helping subroutinges for main.s 
******************************************************************************/

/***************************************
* Voltage pins loop
*       loop through voltage pins and set them high (one at a time)
***************************************/

pinNum .req r0
pinFunc .req r1

/***************************************************
*       Enable necessary pins 
****************************************************/
.globl enableLoop
enableLoop:
	// GROUND PINS (inside pin row on raspberry)
	mov pinNum,#2
	mov pinFunc,#1
	push {lr}
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
	pop {pc}


.unreq pinFunc
pinVal .req r1
.globl voltLoop
voltLoop:
        mov pinNum,#14
        mov pinVal,#1
        //before branching again we have to save link register because it might get overwritten in subroutinge
        push {lr}
        bl SetGpio

        //WAIT
        mov r0, r4
        bl Wait

        mov pinNum,#14
        mov pinVal,#0
        bl SetGpio

        mov pinNum,#15
        mov pinVal,#1
        bl SetGpio

        //WAIT
        mov r0, r4
        bl Wait

        mov pinNum,#15
        mov pinVal,#0
        bl SetGpio

        mov pinNum,#18
        mov pinVal,#1
        bl SetGpio

        //WAIT
        mov r0, r4
        bl Wait

        mov pinNum,#18
        mov pinVal,#0
        bl SetGpio

        mov pinNum,#23
        mov pinVal,#1
        bl SetGpio

        //WAIT
        mov r0, r4
        bl Wait

        mov pinNum,#23
        mov pinVal,#0
        bl SetGpio

        mov pinNum,#24
        mov pinVal,#1
        bl SetGpio

        //WAIT
        mov r0, r4
	bl Wait

	mov pinNum,#24
        mov pinVal,#0
        bl SetGpio

        //WAIT
        mov r0, r4
        bl Wait

        //and now we pop back link register address from stack into the program counter
        pop {pc}

.globl resetLoop
/***************************************************
*       RESET everything subroutine
****************************************************/
resetLoop:
        ///////Set all GND pins highi:
        //first gnd
        mov pinNum,#2
        mov pinVal,#1
        push {lr}
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
        pop {pc}
