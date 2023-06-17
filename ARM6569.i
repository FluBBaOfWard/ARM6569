//
//  ARM6569.i
//  MOS 6569 "VICII" chip emulator for ARM32.
//
//  Created by Fredrik Ahlström on 2006-12-01.
//  Copyright © 2006-2023 Fredrik Ahlström. All rights reserved.
//
;@ ASM header for the MOS 6569 emulator

#include "../ARM6502/M6502.i"
				;@ r0,r1,r2=temp regs
	vic2ptr		.req r10		;@ Same as m6502ptr
	addy		.req r12		;@ Keep this at r12 (scratch for APCS)

	.struct m6502Size			;@ Changes section so make sure it is set before real code.
m6569Start:
m6569StateStart:
m6569Registers:
vicSpr0X:		.byte 0			;@ 0x00 Sprite 0 X Position
vicSpr0Y:		.byte 0			;@ 0x01 Sprite 0 Y Position
vicSpr1X:		.byte 0			;@ 0x02 Sprite 1 X Position
vicSpr1Y:		.byte 0			;@ 0x03 Sprite 1 Y Position
vicSpr2X:		.byte 0			;@ 0x04 Sprite 2 X Position
vicSpr2Y:		.byte 0			;@ 0x05 Sprite 2 Y Position
vicSpr3X:		.byte 0			;@ 0x06 Sprite 3 X Position
vicSpr3Y:		.byte 0			;@ 0x07 Sprite 3 Y Position
vicSpr4X:		.byte 0			;@ 0x08 Sprite 4 X Position
vicSpr4Y:		.byte 0			;@ 0x09 Sprite 4 Y Position
vicSpr5X:		.byte 0			;@ 0x0A Sprite 5 X Position
vicSpr5Y:		.byte 0			;@ 0x0B Sprite 5 Y Position
vicSpr6X:		.byte 0			;@ 0x0C Sprite 6 X Position
vicSpr6Y:		.byte 0			;@ 0x0D Sprite 6 Y Position
vicSpr7X:		.byte 0			;@ 0x0E Sprite 7 X Position
vicSpr7Y:		.byte 0			;@ 0x0F Sprite 7 Y Position
vicSprXPos:		.byte 0			;@ 0x10 Sprites X Pos MSB
vicCtrl1:		.byte 0			;@ 0x11
vicRaster:		.byte 0			;@ 0x12
vicLightPenX:	.byte 0			;@ 0x13
vicLightPenY:	.byte 0			;@ 0x14
vicSprEnable:	.byte 0			;@ 0x15
vicCtrl2:		.byte 0			;@ 0x16
vicSprExpY:		.byte 0			;@ 0x17 Sprite Expand Y
vicMemCtrl:		.byte 0			;@ 0x18
vicIrqFlag:		.byte 0			;@ 0x19
vicIrqEnable:	.byte 0			;@ 0x1A
vicSprPrio:		.byte 0			;@ 0x1B
vicSprMode:		.byte 0			;@ 0x1C
vicSprExpX:		.byte 0			;@ 0x1D Sprite Expand X
vicSprSprCol:	.byte 0			;@ 0x1E Sprite to Sprite Collision
vicSprBgrCol:	.byte 0			;@ 0x1F Sprite to Background Collision
vicBrdCol:		.byte 0			;@ 0x20
vicBgr0Col:		.byte 0			;@ 0x21
vicBgr1Col:		.byte 0			;@ 0x22
vicBgr2Col:		.byte 0			;@ 0x23
vicBgr3Col:		.byte 0			;@ 0x24
vicSprM0Col:	.byte 0			;@ 0x25
vicSprM1Col:	.byte 0			;@ 0x26
vicSpr0Col:		.byte 0			;@ 0x27
vicSpr1Col:		.byte 0			;@ 0x28
vicSpr2Col:		.byte 0			;@ 0x29
vicSpr3Col:		.byte 0			;@ 0x2A
vicSpr4Col:		.byte 0			;@ 0x2B
vicSpr5Col:		.byte 0			;@ 0x2C
vicSpr6Col:		.byte 0			;@ 0x2D
vicSpr7Col:		.byte 0			;@ 0x2E
vicEmpty0:		.byte 0			;@ 0x2F

scanline:		.long 0			;@ Current scanline
lastscanline:	.long 0			;@
scrollXLine:	.long 0			;@
vicTVSystem:	.byte 0			;@
vicMemoryBank:	.byte 0			;@ Which of the four 16k memory banks that is currently mapped in.
vicPadding:		.skip 2			;@
m6569StateEnd:
vicMapBase:		.long 0
vicChrBase:		.long 0
vicBmpBase:		.long 0
vicIrqFunc:		.long 0
m6569End:

m6569Size = m6569End - m6569Start
m6569StateSize = m6569StateEnd-m6569StateStart

;@----------------------------------------------------------------------------
