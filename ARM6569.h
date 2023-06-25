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

//--------------------------- VIC II types -----------------------------------
/// Should not be used.
#define VICAUTO			(0x00)
/// VIC II Early NTSC
#define VIC6567			(0x01)
/// VIC II Early PAL
#define VIC6569			(0x02)
/// VIC II Later NTSC
#define VDP8562			(0x05)
/// VIC II Later PAL
#define VDP8565			(0x06)

/// PAL timing =)
#define PAL_TIMING		(2)

typedef struct {
	/// 0x00 Sprite 0 X Position
	u8 spr0X;
	/// 0x01 Sprite 0 Y Position
	u8 spr0Y;
	/// 0x02 Sprite 1 X Position
	u8 spr1X;
	/// 0x03 Sprite 1 Y Position
	u8 spr1Y;
	/// 0x04 Sprite 2 X Position
	u8 spr2X;
	/// 0x05 Sprite 2 Y Position
	u8 spr2Y;
	/// 0x06 Sprite 3 X Position
	u8 spr3X;
	/// 0x07 Sprite 3 Y Position
	u8 spr3Y;
	/// 0x08 Sprite 4 X Position
	u8 spr4X;
	/// 0x09 Sprite 4 Y Position
	u8 spr4Y;
	/// 0x0A Sprite 5 X Position
	u8 spr5X;
	/// 0x0B Sprite 5 Y Position
	u8 spr5Y;
	/// 0x0C Sprite 6 X Position
	u8 spr6X;
	/// 0x0D Sprite 6 Y Position
	u8 spr6Y;
	/// 0x0E Sprite 7 X Position
	u8 spr7X;
	/// 0x0F Sprite 7 Y Position
	u8 spr7Y;
	/// 0x10 Sprites X Pos MSB
	u8 sprXPos;
	/// 0x11
	u8 ctrl1;
	/// 0x12
	u8 raster;
	/// 0x13
	u8 lightPenX;
	/// 0x14
	u8 lightPenY;
	/// 0x15
	u8 sprEnable;
	/// 0x16
	u8 ctrl2;
	/// 0x17 Sprite Expand Y
	u8 sprExpY;
	/// 0x18
	u8 memCtrl;
	/// 0x19
	u8 irqFlag;
	/// 0x1A
	u8 irqEnable;
	/// 0x1B
	u8 sprPrio;
	/// 0x1C
	u8 sprMode;
	/// 0x1D Sprite Expand X
	u8 sprExpX;
	/// 0x1E  Sprite to Sprite Collision
	u8 sprSprCol;
	/// 0x1F  Sprite to Background Collision
	u8 sprBgrCol;
	/// 0x20
	u8 brdCol;
	/// 0x21
	u8 bgr0Col;
	/// 0x22
	u8 bgr1Col;
	/// 0x23
	u8 bgr2Col;
	/// 0x24
	u8 bgr3Col;
	/// 0x25
	u8 sprM0Col;
	/// 0x26
	u8 sprM1Col;
	/// 0x27
	u8 spr0Col;
	/// 0x28
	u8 spr1Col;
	/// 0x29
	u8 spr2Col;
	/// 0x2A
	u8 spr3Col;
	/// 0x2B
	u8 spr4Col;
	/// 0x2C
	u8 spr5Col;
	/// 0x2D
	u8 spr6Col;
	// 0x2E
	u8 spr7Col;
	/// 0x2F
	u8 empty0;

	/// Current scanline
	u32 scanline;
	u32 lastscanline;
	u32 scrollXLine;
	u8 tvSystem;
	/// Which of the four 16k memory banks that is currently mapped in.
	u8 memoryBank;
	u8 padding[2];
	u8 *mapBase;
	u8 *chrBase;
	u8 *bmpBase;
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
