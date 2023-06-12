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
	.global VIC_ctrl2_W

	.syntax unified
	.arm

#ifdef GBA
	.section .ewram, "ax", %progbits	;@ For the GBA
#else
	.section .text						;@ For anything else
#endif
	.align 2

;@----------------------------------------------------------------------------
m6569Init:					;@ r0 = VICII chip.
;@----------------------------------------------------------------------------
	adr r1,dummyFunc
//	str r1,[r0,#ciaIrqFunc]
;@----------------------------------------------------------------------------
m6569Reset:					;@ r0 = VICII chip.
;@----------------------------------------------------------------------------
	stmfd sp!,{lr}

	mov r1,#0
	mov r2,#m6569StateSize/4	;@ 36/4=9
	bl memset_					;@ Clear variables

	mov r1,#0x01				;@ TimerA enabled?
//	strb r1,[r0,#ciaIrqCtrl]
//	strb r1,[r0,#ciaTodRunning]	;@ Running?

	mov r1,#-1
//	str r1,[r0,#ciaTimerACount]
//	str r1,[r0,#ciaTimerBCount]

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
m6569Read:					;@ r2 = VICII chip, r12 = adr.
;@----------------------------------------------------------------------------
;@----------------------------------------------------------------------------
VIC_R:
;@----------------------------------------------------------------------------
	and r1,addy,#0x3F
	cmp r1,#0x2F
	ldrmi pc,[pc,r1,lsl#2]
;@---------------------------
	b VIC_empty_R
;@ VIC_read_tbl
	.long VIC_default_R		;@ 0xD000
	.long VIC_default_R		;@ 0xD001
	.long VIC_default_R		;@ 0xD002
	.long VIC_default_R		;@ 0xD003
	.long VIC_default_R		;@ 0xD004
	.long VIC_default_R		;@ 0xD005
	.long VIC_default_R		;@ 0xD006
	.long VIC_default_R		;@ 0xD007
	.long VIC_default_R		;@ 0xD008
	.long VIC_default_R		;@ 0xD009
	.long VIC_default_R		;@ 0xD00A
	.long VIC_default_R		;@ 0xD00B
	.long VIC_default_R		;@ 0xD00C
	.long VIC_default_R		;@ 0xD00D
	.long VIC_default_R		;@ 0xD00E
	.long VIC_default_R		;@ 0xD00F
	.long VIC_default_R		;@ 0xD010
	.long VIC_ctrl1_R		;@ 0xD011
	.long VIC_scanline_R	;@ 0xD012
	.long VIC_default_R		;@ 0xD013
	.long VIC_default_R		;@ 0xD014
	.long VIC_default_R		;@ 0xD015
	.long VIC_ctrl2_R		;@ 0xD016
	.long VIC_default_R		;@ 0xD017
	.long VIC_memctrl_R		;@ 0xD018
	.long VIC_irqflag_R		;@ 0xD019
	.long VIC_irqenable_R	;@ 0xD01A
	.long VIC_default_R		;@ 0xD01B
	.long VIC_default_R		;@ 0xD01C
	.long VIC_default_R		;@ 0xD01D
	.long VIC_default_R		;@ 0xD01E
	.long VIC_default_R		;@ 0xD01F
	.long VIC_palette_R		;@ 0xD020
	.long VIC_palette_R		;@ 0xD021
	.long VIC_palette_R		;@ 0xD022
	.long VIC_palette_R		;@ 0xD023
	.long VIC_palette_R		;@ 0xD024
	.long VIC_palette_R		;@ 0xD025
	.long VIC_palette_R		;@ 0xD026
	.long VIC_palette_R		;@ 0xD027
	.long VIC_palette_R		;@ 0xD028
	.long VIC_palette_R		;@ 0xD029
	.long VIC_palette_R		;@ 0xD02A
	.long VIC_palette_R		;@ 0xD02B
	.long VIC_palette_R		;@ 0xD02C
	.long VIC_palette_R		;@ 0xD02D
	.long VIC_palette_R		;@ 0xD02E

VIC_default_R:
	add r2,r10,#m6569Registers
	ldrb r0,[r2,r1]
	bx lr

;@----------------------------------------------------------------------------
VIC_ctrl1_R:		;@ 0xD011
;@----------------------------------------------------------------------------
	ldr r1,[r10,#scanline]
	and r1,r1,#0x100
	ldrb r0,[r10,#vicCtrl1]
	and r0,r0,#0x7F
	orr r0,r0,r1,lsr#1
	bx lr
;@----------------------------------------------------------------------------
VIC_scanline_R:		;@ 0xD012
;@----------------------------------------------------------------------------
	ldrb r0,[r10,#scanline]
	bx lr
;@----------------------------------------------------------------------------
VIC_ctrl2_R:		;@ 0xD016
;@----------------------------------------------------------------------------
	ldrb r0,[r10,#vicCtrl2]
	orr r0,r0,#0xC0
	bx lr
;@----------------------------------------------------------------------------
VIC_memctrl_R:		;@ 0xD018
;@----------------------------------------------------------------------------
	ldrb r0,[r10,#vicMemCtrl]
	orr r0,r0,#0x01
	bx lr
;@----------------------------------------------------------------------------
VIC_irqflag_R:		;@ 0xD019
;@----------------------------------------------------------------------------
//	mov r11,r11
	ldrb r0,[r10,#vicIrqFlag]
	ands r0,r0,#0x0F
	orrne r0,r0,#0x80
	orr r0,r0,#0x70
	bx lr
;@----------------------------------------------------------------------------
VIC_irqenable_R:	;@ 0xD01A
;@----------------------------------------------------------------------------
	ldrb r0,[r10,#vicIrqEnable]
	orr r0,r0,#0xF0
	bx lr
;@----------------------------------------------------------------------------
VIC_palette_R:		;@ 0xD020 -> 0xD02E
;@----------------------------------------------------------------------------
	add r2,r10,#m6569Registers
	ldrb r0,[r2,r1]
	orr r0,r0,#0xF0
	bx lr
;@----------------------------------------------------------------------------
VIC_empty_R:		;@ 0xD02F -> 0xD03F
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
//VIC_write_tbl
	.long VIC_default_W		;@ 0xD000
	.long VIC_default_W		;@ 0xD001
	.long VIC_default_W		;@ 0xD002
	.long VIC_default_W		;@ 0xD003
	.long VIC_default_W		;@ 0xD004
	.long VIC_default_W		;@ 0xD005
	.long VIC_default_W		;@ 0xD006
	.long VIC_default_W		;@ 0xD007
	.long VIC_default_W		;@ 0xD008
	.long VIC_default_W		;@ 0xD009
	.long VIC_default_W		;@ 0xD00A
	.long VIC_default_W		;@ 0xD00B
	.long VIC_default_W		;@ 0xD00C
	.long VIC_default_W		;@ 0xD00D
	.long VIC_default_W		;@ 0xD00E
	.long VIC_default_W		;@ 0xD00F
	.long VIC_default_W		;@ 0xD010
	.long VIC_ctrl1_W		;@ 0xD011
	.long VIC_default_W		;@ 0xD012
	.long VIC_default_W		;@ 0xD013
	.long VIC_default_W		;@ 0xD014
	.long VIC_default_W		;@ 0xD015
	.long VIC_ctrl2_W		;@ 0xD016
	.long VIC_default_W		;@ 0xD017
	.long VIC_memctrl_W		;@ 0xD018
	.long VIC_irqflag_W		;@ 0xD019
	.long VIC_default_W		;@ 0xD01A
	.long VIC_default_W		;@ 0xD01B
	.long VIC_default_W		;@ 0xD01C
	.long VIC_default_W		;@ 0xD01D
	.long VIC_default_W		;@ 0xD01E
	.long VIC_default_W		;@ 0xD01F
	.long VIC_default_W		;@ 0xD020
	.long VIC_default_W		;@ 0xD021
	.long VIC_default_W		;@ 0xD022
	.long VIC_default_W		;@ 0xD023
	.long VIC_default_W		;@ 0xD024
	.long VIC_default_W		;@ 0xD025
	.long VIC_default_W		;@ 0xD026
	.long VIC_default_W		;@ 0xD027
	.long VIC_default_W		;@ 0xD028
	.long VIC_default_W		;@ 0xD029
	.long VIC_default_W		;@ 0xD02A
	.long VIC_default_W		;@ 0xD02B
	.long VIC_default_W		;@ 0xD02C
	.long VIC_default_W		;@ 0xD02D
	.long VIC_default_W		;@ 0xD02E


VIC_default_W:
//	mov r11,r11
	add r2,r10,#m6569Registers
	strb r0,[r2,r1]
	bx lr

;@----------------------------------------------------------------------------
VIC_ctrl1_W:		;@ 0xD011
;@----------------------------------------------------------------------------
	strb r0,[r10,#vicCtrl1]
	b SetC64GfxMode
;@----------------------------------------------------------------------------
VIC_ctrl2_W:		;@ 0xD016
;@----------------------------------------------------------------------------
	stmfd sp!,{r0,r12}
	ldrb r1,[r10,#vicCtrl2]
	strb r0,[r10,#vicCtrl2]
	and r1,r1,#7

	ldr addy,[r10,#scanline]	;@ addy=scanline
	subs addy,addy,#50
	bmi exit_sx
	cmp addy,#200
	movhi addy,#200
	ldr r0,[r10,#scrollXLine]
	cmp r0,addy
	bhi exit_sx
	str addy,[r10,#scrollXLine]

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
VIC_memctrl_W:		;@ 0xD018
;@----------------------------------------------------------------------------
	strb r0,[r10,#vicMemCtrl]
	b SetC64GfxBases
;@----------------------------------------------------------------------------
VIC_irqflag_W:		;@ 0xD019
;@----------------------------------------------------------------------------
//	mov r11,r11
	ldrb r1,[r10,#vicIrqFlag]
	bic r1,r1,r0
	strb r1,[r10,#vicIrqFlag]
	bx lr


;@----------------------------------------------------------------------------

	.end
#endif // #ifdef __arm__
