# ARM6569
A MOS 6567/6569/8562/8565 "VIC-II" (Video Interface Controller) chip emulator for ARM32.

First you need to allocate space for the chip core state, either by using the struct from C or allocating/reserving memory using the "m6526Size"
Next call m6569Init with a pointer to that memory.
