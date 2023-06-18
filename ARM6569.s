//
//  ARM6569.s
//  MOS 6569 "VICII" chip emulator for ARM32.
//
//  Created by Fredrik Ahlström on 2006-12-01.
//  Copyright © 2006-2023 Fredrik Ahlström. All rights reserved.
//

#ifdef __arm__

#include "ARM6569.i"

	.global m6569Init
	.global m6569Reset
	.global VIC_R
	.global VIC_W
	.global m6569Read
	.global m6569Write
	.global m6569DoScanline
	.global m6569SaveState
	.global m6569LoadState
	.global m6569GetStateSize
	.global m6569SetMemBank
	.global vicCtrl2W

	.syntax unified
	.arm

#ifdef GBA
	.section .ewram, "ax", %progbits	;@ For the GBA
#else
	.section .text						;@ For anything else
#endif
	.align 2

;@----------------------------------------------------------------------------
m6569Init:					;@ r10 = VICII chip.
;@----------------------------------------------------------------------------
	adr r1,dummyFunc
	str r1,[vic2ptr,#vicIrqFunc]
;@----------------------------------------------------------------------------
m6569Reset:					;@ r10 = VICII chip.
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}

	add r0,vic2ptr,#m6569StateStart
	mov r1,#0
	mov r2,#m6569StateSize/4	;@ 36/4=9
	bl memset_					;@ Clear variables

	mov r1,#0x01				;@ TimerA enabled?
//	strb r1,[vic2ptr,#ciaIrqCtrl]
//	strb r1,[vic2ptr,#ciaTodRunning]	;@ Running?

	mov r1,#-1
//	str r1,[vic2ptr,#ciaTimerACount]
//	str r1,[vic2ptr,#ciaTimerBCount]

	ldmfd sp!,{lr}
	bx lr
dummyFunc:
	mov r0,#0xFF
	bx lr

;@----------------------------------------------------------------------------
memCopy:
;@----------------------------------------------------------------------------
	ldr r3,=memcpy
;@----------------------------------------------------------------------------
thumbCallR3:
;@----------------------------------------------------------------------------
	bx r3
;@----------------------------------------------------------------------------
m6569SaveState:		;@ In r0=destination, r1=VICII chip. Out r0=state size.
	.type m6569SaveState STT_FUNC
;@----------------------------------------------------------------------------
	add r1,r1,#m6569StateStart
	mov r2,#m6569StateSize
	stmfd sp!,{r2,lr}
	bl memCopy

	ldmfd sp!,{r0,lr}
	bx lr
;@----------------------------------------------------------------------------
m6569LoadState:		;@ In r0=VICII chip, r1=source. Out r0=state size.
	.type m6569LoadState STT_FUNC
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}

	add r0,r0,#m6569StateStart
	mov r2,#m6569StateSize
	bl memCopy

	ldmfd sp!,{lr}
;@----------------------------------------------------------------------------
m6569GetStateSize:	;@ Out r0=state size.
	.type m6569GetStateSize STT_FUNC
;@----------------------------------------------------------------------------
	mov r0,#m6569StateSize
	bx lr

;@----------------------------------------------------------------------------
m6569DoScanline:
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}
	ldr r1,[vic2ptr,#scanline]
	bl RenderLine

VICRasterCheck:
	ldrb r0,[vic2ptr,#vicRaster]
	ldrb r2,[vic2ptr,#vicCtrl1]
	tst r2,#0x80
	orrne r0,r0,#0x100
	cmp r0,r1
	bne noRasterIrq
	ldrb r0,[vic2ptr,#vicIrqFlag]
	orr r0,r0,#1
	strb r0,[vic2ptr,#vicIrqFlag]

	ldrb r2,[vic2ptr,#vicIrqEnable]
	ands r0,r0,r2
	movne lr,pc
	ldrne pc,[vic2ptr,#vicIrqFunc]
noRasterIrq:

	add r1,r1,#1
	str r1,[vic2ptr,#scanline]
	ldr r0,[vic2ptr,#lastscanline]
	sub r0,r0,r1
	ldmfd sp!,{lr}
	bx lr
;@----------------------------------------------------------------------------
m6569Read:					;@ r2 = VICII chip, r12 = adr.
;@----------------------------------------------------------------------------
;@----------------------------------------------------------------------------
VIC_R:
;@----------------------------------------------------------------------------
	and r1,addy,#0x3F
	cmp r1,#0x2F
	ldrmi pc,[pc,r1,lsl#2]
;@---------------------------
	b vicEmptyR
;@ vicReadTable
	.long vicDefaultR		;@ 0xD000
	.long vicDefaultR		;@ 0xD001
	.long vicDefaultR		;@ 0xD002
	.long vicDefaultR		;@ 0xD003
	.long vicDefaultR		;@ 0xD004
	.long vicDefaultR		;@ 0xD005
	.long vicDefaultR		;@ 0xD006
	.long vicDefaultR		;@ 0xD007
	.long vicDefaultR		;@ 0xD008
	.long vicDefaultR		;@ 0xD009
	.long vicDefaultR		;@ 0xD00A
	.long vicDefaultR		;@ 0xD00B
	.long vicDefaultR		;@ 0xD00C
	.long vicDefaultR		;@ 0xD00D
	.long vicDefaultR		;@ 0xD00E
	.long vicDefaultR		;@ 0xD00F
	.long vicDefaultR		;@ 0xD010
	.long vicCtrl1R			;@ 0xD011
	.long vicScanlineR		;@ 0xD012
	.long vicDefaultR		;@ 0xD013
	.long vicDefaultR		;@ 0xD014
	.long vicDefaultR		;@ 0xD015
	.long vicCtrl2R			;@ 0xD016
	.long vicDefaultR		;@ 0xD017
	.long vicMemCtrlR		;@ 0xD018
	.long vicIrqFlagR		;@ 0xD019
	.long vicIrqEnableR		;@ 0xD01A
	.long vicDefaultR		;@ 0xD01B
	.long vicDefaultR		;@ 0xD01C
	.long vicDefaultR		;@ 0xD01D
	.long vicDefaultR		;@ 0xD01E
	.long vicDefaultR		;@ 0xD01F
	.long vicPaletteR		;@ 0xD020
	.long vicPaletteR		;@ 0xD021
	.long vicPaletteR		;@ 0xD022
	.long vicPaletteR		;@ 0xD023
	.long vicPaletteR		;@ 0xD024
	.long vicPaletteR		;@ 0xD025
	.long vicPaletteR		;@ 0xD026
	.long vicPaletteR		;@ 0xD027
	.long vicPaletteR		;@ 0xD028
	.long vicPaletteR		;@ 0xD029
	.long vicPaletteR		;@ 0xD02A
	.long vicPaletteR		;@ 0xD02B
	.long vicPaletteR		;@ 0xD02C
	.long vicPaletteR		;@ 0xD02D
	.long vicPaletteR		;@ 0xD02E

vicDefaultR:
	add r2,vic2ptr,#m6569Registers
	ldrb r0,[r2,r1]
	bx lr

;@----------------------------------------------------------------------------
vicCtrl1R:			;@ 0xD011
;@----------------------------------------------------------------------------
	ldr r1,[vic2ptr,#scanline]
	and r1,r1,#0x100
	ldrb r0,[vic2ptr,#vicCtrl1]
	and r0,r0,#0x7F
	orr r0,r0,r1,lsr#1
	bx lr
;@----------------------------------------------------------------------------
vicScanlineR:		;@ 0xD012
;@----------------------------------------------------------------------------
	ldrb r0,[vic2ptr,#scanline]
	bx lr
;@----------------------------------------------------------------------------
vicCtrl2R:			;@ 0xD016
;@----------------------------------------------------------------------------
	ldrb r0,[vic2ptr,#vicCtrl2]
	orr r0,r0,#0xC0
	bx lr
;@----------------------------------------------------------------------------
vicMemCtrlR:		;@ 0xD018
;@----------------------------------------------------------------------------
	ldrb r0,[vic2ptr,#vicMemCtrl]
	orr r0,r0,#0x01
	bx lr
;@----------------------------------------------------------------------------
vicIrqFlagR:		;@ 0xD019
;@----------------------------------------------------------------------------
	ldrb r0,[vic2ptr,#vicIrqFlag]
	ldrb r1,[vic2ptr,#vicIrqEnable]
	ands r0,r0,r1
	orrne r0,r0,#0x80
	orr r0,r0,#0x70
	bx lr
;@----------------------------------------------------------------------------
vicIrqEnableR:		;@ 0xD01A
;@----------------------------------------------------------------------------
	ldrb r0,[vic2ptr,#vicIrqEnable]
	orr r0,r0,#0xF0
	bx lr
;@----------------------------------------------------------------------------
vicPaletteR:		;@ 0xD020 -> 0xD02E
;@----------------------------------------------------------------------------
	add r2,vic2ptr,#m6569Registers
	ldrb r0,[r2,r1]
	orr r0,r0,#0xF0
	bx lr
;@----------------------------------------------------------------------------
vicEmptyR:			;@ 0xD02F -> 0xD03F
;@----------------------------------------------------------------------------
	mov r11,r11
	mov r0,#0xFF
	bx lr

;@----------------------------------------------------------------------------
m6569Write:					;@ r0 = value, r2 = VICII chip, r12 = adr.
;@----------------------------------------------------------------------------
;@----------------------------------------------------------------------------
VIC_W:
;@----------------------------------------------------------------------------
	and r1,addy,#0x3F
	cmp r1,#0x2F
	ldrmi pc,[pc,r1,lsl#2]
;@---------------------------
	bx lr
;@ vicWriteTable
	.long vicDefaultW		;@ 0xD000
	.long vicDefaultW		;@ 0xD001
	.long vicDefaultW		;@ 0xD002
	.long vicDefaultW		;@ 0xD003
	.long vicDefaultW		;@ 0xD004
	.long vicDefaultW		;@ 0xD005
	.long vicDefaultW		;@ 0xD006
	.long vicDefaultW		;@ 0xD007
	.long vicDefaultW		;@ 0xD008
	.long vicDefaultW		;@ 0xD009
	.long vicDefaultW		;@ 0xD00A
	.long vicDefaultW		;@ 0xD00B
	.long vicDefaultW		;@ 0xD00C
	.long vicDefaultW		;@ 0xD00D
	.long vicDefaultW		;@ 0xD00E
	.long vicDefaultW		;@ 0xD00F
	.long vicDefaultW		;@ 0xD010
	.long vicCtrl1W			;@ 0xD011
	.long vicDefaultW		;@ 0xD012
	.long vicDefaultW		;@ 0xD013
	.long vicDefaultW		;@ 0xD014
	.long vicDefaultW		;@ 0xD015
	.long vicCtrl2W			;@ 0xD016
	.long vicDefaultW		;@ 0xD017
	.long vicMemCtrlW		;@ 0xD018
	.long vicIrqFlagW		;@ 0xD019
	.long vicIrqEnableW		;@ 0xD01A
	.long vicDefaultW		;@ 0xD01B
	.long vicDefaultW		;@ 0xD01C
	.long vicDefaultW		;@ 0xD01D
	.long vicDefaultW		;@ 0xD01E
	.long vicDefaultW		;@ 0xD01F
	.long vicDefaultW		;@ 0xD020
	.long vicDefaultW		;@ 0xD021
	.long vicDefaultW		;@ 0xD022
	.long vicDefaultW		;@ 0xD023
	.long vicDefaultW		;@ 0xD024
	.long vicDefaultW		;@ 0xD025
	.long vicDefaultW		;@ 0xD026
	.long vicDefaultW		;@ 0xD027
	.long vicDefaultW		;@ 0xD028
	.long vicDefaultW		;@ 0xD029
	.long vicDefaultW		;@ 0xD02A
	.long vicDefaultW		;@ 0xD02B
	.long vicDefaultW		;@ 0xD02C
	.long vicDefaultW		;@ 0xD02D
	.long vicDefaultW		;@ 0xD02E

vicDefaultW:
//	mov r11,r11
	add r2,vic2ptr,#m6569Registers
	strb r0,[r2,r1]
	bx lr

;@----------------------------------------------------------------------------
vicCtrl1W:			;@ 0xD011
;@----------------------------------------------------------------------------
	strb r0,[vic2ptr,#vicCtrl1]
	b SetC64GfxMode
;@----------------------------------------------------------------------------
vicCtrl2W:			;@ 0xD016
;@----------------------------------------------------------------------------
	stmfd sp!,{r0,r12}
	ldrb r1,[vic2ptr,#vicCtrl2]
	strb r0,[vic2ptr,#vicCtrl2]
	and r1,r1,#7

	ldr addy,[vic2ptr,#scanline]	;@ addy=scanline
	subs addy,addy,#50
	bmi exit_sx
	cmp addy,#200
	movhi addy,#200
	ldr r0,[vic2ptr,#scrollXLine]
	cmp r0,addy
	bhi exit_sx
	str addy,[vic2ptr,#scrollXLine]

	ldr r2,=scroll_ptr0
	ldr r2,[r2]
	add r0,r2,r0
	add r2,r2,addy
sx1:
	strb r1,[r2],#-1			;@ Fill backwards from scanline to lastline
	cmp r2,r0
	bpl sx1
exit_sx:
	ldmfd sp!,{r0,r12}
	b SetC64GfxMode
//	bx lr

;@----------------------------------------------------------------------------
vicMemCtrlW:		;@ 0xD018
;@----------------------------------------------------------------------------
	strb r0,[vic2ptr,#vicMemCtrl]
	b setGfxBases
;@----------------------------------------------------------------------------
vicIrqFlagW:		;@ 0xD019
;@----------------------------------------------------------------------------
	ldrb r1,[vic2ptr,#vicIrqFlag]
	bic r1,r1,r0
	strb r1,[vic2ptr,#vicIrqFlag]
	ldrb r0,[vic2ptr,#vicIrqEnable]
	ands r0,r1,r0
	ldreq pc,[vic2ptr,#vicIrqFunc]
	bx lr
;@----------------------------------------------------------------------------
vicIrqEnableW:		;@ 0xD01A
;@----------------------------------------------------------------------------
	and r0,r0,#0xF
	strb r0,[vic2ptr,#vicIrqEnable]
	ldrb r1,[vic2ptr,#vicIrqFlag]
	ands r0,r1,r0
	ldr pc,[vic2ptr,#vicIrqFunc]

;@----------------------------------------------------------------------------
m6569SetMemBank:			;@ Set memory bank
;@----------------------------------------------------------------------------
	eor r0,r0,#0x03
	and r0,r0,#0x03
	strb r0,[vic2ptr,#vicMemoryBank]
;@----------------------------------------------------------------------------
setGfxBases:
;@----------------------------------------------------------------------------
	stmfd sp!,{r0,r12}
	ldrb r0,[vic2ptr,#vicMemoryBank]
	ldrb r2,[vic2ptr,#vicMemCtrl]	;@ 0xD018
	and r1,r2,#0xF0
	orr r1,r1,r0,lsl#8
	add r1,m6502zpage,r1,lsl#6

	str r1,[vic2ptr,#vicMapBase]

	and r1,r2,#0x0E
	orr r0,r1,r0,lsl#4

	and r1,r0,#0x1C
	cmp r1,#0x04				;@ 0x1000/0x9000
	ldreq r2,=Chargen			;@ r2 = CHRROM
	movne r2,m6502zpage			;@ r2 = RAM

	bic r1,r0,#0x07
	add r1,r2,r1,lsl#10
	str r1,[vic2ptr,#vicBmpBase]

	andeq r0,r0,#0x02
	add r1,r2,r0,lsl#10
	str r1,[vic2ptr,#vicChrBase]

	ldmfd sp!,{r0,r12}
	bx lr
;@----------------------------------------------------------------------------

	.end
#endif // #ifdef __arm__
