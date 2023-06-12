//
//  ARM6569.h
//  MOS 6569 "VICII" chip emulator for ARM32.
//
//  Created by Fredrik Ahlström on 2006-12-01.
//  Copyright © 2006-2023 Fredrik Ahlström. All rights reserved.
//

#ifndef ARM6569_HEADER
#define ARM6569_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
	/// 0x00 Sprite 0 X Position
	u8 vicSpr0X;
	/// 0x01 Sprite 0 Y Position
	u8 vicSpr0Y;
	/// 0x02 Sprite 1 X Position
	u8 vicSpr1X;
	/// 0x03 Sprite 1 Y Position
	u8 vicSpr1Y;
	/// 0x04 Sprite 2 X Position
	u8 vicSpr2X;
	/// 0x05 Sprite 2 Y Position
	u8 vicSpr2Y;
	/// 0x06 Sprite 3 X Position
	u8 vicSpr3X;
	/// 0x07 Sprite 3 Y Position
	u8 vicSpr3Y;
	/// 0x08 Sprite 4 X Position
	u8 vicSpr4X;
	/// 0x09 Sprite 4 Y Position
	u8 vicSpr4Y;
	/// 0x0A Sprite 5 X Position
	u8 vicSpr5X;
	/// 0x0B Sprite 5 Y Position
	u8 vicSpr5Y;
	/// 0x0C Sprite 6 X Position
	u8 vicSpr6X;
	/// 0x0D Sprite 6 Y Position
	u8 vicSpr6Y;
	/// 0x0E Sprite 7 X Position
	u8 vicSpr7X;
	/// 0x0F Sprite 7 Y Position
	u8 vicSpr7Y;
	/// 0x10 Sprites X Pos MSB
	u8 vicSprXPos;
	/// 0x11
	u8 vicCtrl1;
	/// 0x12
	u8 vicRaster;
	/// 0x13
	u8 vicLightPenX;
	/// 0x14
	u8 vicLightPenY;
	/// 0x15
	u8 vicSprEnable;
	/// 0x16
	u8 vicCtrl2;
	/// 0x17
	u8 vicSprExpY;
	/// 0x18
	u8 vicMemCtrl;
	/// 0x19
	u8 vicIrqFlag;
	/// 0x1A
	u8 vicIrqEnable;
	/// 0x1B
	u8 vicSprPrio;
	/// 0x1C
	u8 vicSprMode;
	/// 0x1D
	u8 vicSprExpX;
	/// 0x1E
	u8 vicSprSprCol;
	/// 0x1F
	u8 vicSprBgrCol;
	/// 0x20
	u8 vicBrdCol;
	/// 0x21
	u8 vicBgr0Col;
	/// 0x22
	u8 vicBgr1Col;
	/// 0x23
	u8 vicBgr2Col;
	/// 0x24
	u8 vicBgr3Col;
	/// 0x25
	u8 vicSprM0Col;
	/// 0x26
	u8 vicSprM1Col;
	/// 0x27
	u8 vicSpr0Col;
	/// 0x28
	u8 vicSpr1Col;
	/// 0x29
	u8 vicSpr2Col;
	/// 0x2A
	u8 vicSpr3Col;
	/// 0x2B
	u8 vicSpr4Col;
	/// 0x2C
	u8 vicSpr5Col;
	/// 0x2D
	u8 vicSpr6Col;
	// 0x2E
	u8 vicSpr7Col;
	/// 0x2F
	u8 vicEmpty0;

	/// Current scanline
	u32 scanline;
	u32 lastscanline;
	u32 scrollXLine;
	u8 vicTVSystem;
	u8 vicPadding[3];
	/// The function to call when IRQ happens
	u32 *irqFunc;
} M6569;


/**
 * Initializes the port and irq functions and calls reset.
 * @param  *chip: The M6569 chip to initialize.
 */
void m6569Init(const M6569 *chip);

/**
 * Initializes the state of the chip
 * @param  *chip: The M6569 chip to reset.
 */
void m6569Reset(const M6569 *chip);

/**
 * Saves the state of the M6569 chip to the destination.
 * @param  *destination: Where to save the state.
 * @param  *chip: The M6569 chip to save.
 * @return The size of the state.
 */
int m6569SaveState(void *destination, const M6569 *chip);

/**
 * Loads the state of the M6569 chip from the source.
 * @param  *chip: The M6569 chip to load a state into.
 * @param  *source: Where to load the state from.
 * @return The size of the state.
 */
int m6569LoadState(M6569 *chip, const void *source);

/**
 * Gets the state size of a M6569.
 * @return The size of the state.
 */
int m6569GetStateSize(void);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // ARM6569_HEADER
