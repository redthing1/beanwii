module emu.hw.memory.strategy.memstrategy;

import emu.hw.disk.dol;
import emu.hw.memory.strategy.slowmem.slowmem;
import util.number;

alias Mem = SlowMem;

interface MemStrategy {
    // interfaces cant have templated functions, so we have to do this:
    public u64 read_be_u64(u32 address);
    public u32 read_be_u32(u32 address);
    public u16 read_be_u16(u32 address);
    public u8  read_be_u8 (u32 address);

    public void map_dol(WiiDol* dol);
}
