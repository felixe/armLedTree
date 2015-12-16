/***************************0*************************************************
*       bitMask2LED.s
*       Felix Erlacher, Rainer Böhme, Pascal Schöttle
*       
*	r0 is bitmask to be led
*	r1 is multiplicator how long the leds should shine
*	The 1s in
*	this bitmask are then lighted up on the 5x5 LED Matrix
*       Code is in ARMv6 assembler.
***************************************************************************/


.globl bitMask2LED
bitMask2LED:
	//r6 contains bitmask of leds to shine 
	mov r6, r0	
	//counter for flashLoop. One loop takes ~200microsecs, this is the multiplicator
	mov r8, r1
	push {lr}
	//address of gpio controller
	ldr r9,=0x20200000
	//r1 contains 1s for cathode (gnd) pins with least significant leftmost (00001000000000100000000000011100)
	ldr r1,=0x0802001C
	//r2 contains 1s for anode (V) pins --> 00000001100001001100000000000000
	ldr r2,=0x0184C000
	
	
	//this loop goes through all leds to make tem visible
	flashLoop:
	        //flashloop counter
	        subs r8,r8,#1
	        beq end
	        //r3 contains 1 to set Cathode (-) in gpclr register. First 1 is below first Cathode 1 in r1
	        ldr r3,=0x00000004
	        //same procedure  sr3, 2^14=16384
	        ldr r4,=0x00004000
	        //r5 is counter for LED mask (r6 contains only 25 LEDS but 32 bits)
	        ldr r5,=24
	        //or register to gather all anode pins for on row
	        ldr r10,=0
	//Basic logic: go 5 times through Anodes and gather them in r10, ligth em up (depending if respective bit in r6 is 1). Than move Cathode one further and repeat.
	shiftAnod:
	        //move 1 in r3 left (by rotating it right 31 to preserve mask) until below 1 in r1
	        tst r2,r4
	        moveq r4,r4, ror #31
	        beq shiftAnod
	
	shiftCath:
	        //same  with r3 und r2
	        tst r1,r3
	        moveq r3,r3, ror #31
	        beq shiftCath
	
	coreIO:
	        //check if LED bitmask has a 1 at the r5th bit, and only the light up current LEDs
	        mov r0, r6, lsr r5
	        tst r0, #1
	        //always gather (or) the 5 anodes for one row to light them up together
	        orrne r10,r10,r4
	
	endCore:
	        //25 LED counter 
	        sub r5,r5,#1
	
	        //move once to make r4 move to next 1 in shiftAnod      
	        mov r4,r4, ror #31
	        //only move Cathodes after 5 turns. To save register this is done by comparing it with initial value+1.
	        cmp r4,#0x02000000 //TODO: replace with larger than r2 (unisgned)
	        //while not even do not shift cathodes
	        bne shiftAnod
	
	        //light em up by feeding OR register of Anodes(r10) and one Cathode(r3) 
	        //gpset register for anodes (+)
	        str r10, [r9,#28]
	        //gpclr register for cathodes (-)
	str r3, [r9,#40]
	
	        //wait between rows
	        ldr r0,=40
	        bl wait
	
	        //reset pins
	        str r3, [r9,#28]
	        str r10, [r9,#40]
	        ldr r10,=0
	
	        //and again, move r4 once to make shure it moves on in shiftCath
	        mov r3,r3, ror #31
	
	        //check here if 25 LED counter is negative and ev. branch
	        movs r5, r5
	        bmi flashLoop
	
	        b shiftAnod
	end:	
		pop {pc}

