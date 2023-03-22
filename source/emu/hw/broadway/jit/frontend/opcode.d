module emu.hw.broadway.jit.frontend.opcode;

enum PrimaryOpcode {
    ADDI   = 0x0E,
    ADDIC  = 0x0C,
    ADDIC_ = 0x0D, // since I can't do ADDIC., I'll use ADDIC_ instead
    ADDIS  = 0x0F,
    ANDI   = 0x1C,
    ANDIS  = 0x1D,
    B      = 0x12,
    BC     = 0x10,
    CMPLI  = 0x0A,
    CMPI   = 0x0B,
    LFD    = 0x32,
    LHZ    = 0x28,
    LWZ    = 0x20,
    LWZU   = 0x21,
    LBZU   = 0x23,
    MULLI  = 0x07,
    ORI    = 0x18,
    ORIS   = 0x19,
    PSQ_L  = 0x38,
    RLWIMI = 0x14,
    RLWINM = 0x15,
    RLWNM  = 0x17,
    SC     = 0x11,
    STB    = 0x26,
    STBU   = 0x27,
    STH    = 0x2C,
    STW    = 0x24,
    STWU   = 0x25,
    SUBFIC = 0x08,
    XORI   = 0x1A,
    XORIS  = 0x1B,

    OP_04  = 0x04,
    OP_13  = 0x13,
    OP_1F  = 0x1F,
    OP_3B  = 0x3B,
    OP_3F  = 0x3F,
}

enum PrimaryOp04SecondaryOpcode {
    PS_MR = 0x48
}

enum PrimaryOp13SecondaryOpcode {
    BCCTR  = 0x210,
    BCLR   = 0x010,
    CRXOR  = 0x0C1,
    ISYNC  = 0x096,
}

enum PrimaryOp1FSecondaryOpcode {
    ADD     = 0x10A,
    ADDC    = 0x00A,
    ADDCO   = 0x20A,
    ADDE    = 0x08A,
    ADDEO   = 0x28A,
    ADDO    = 0x30A,
    ADDME   = 0x0EA,
    ADDMEO  = 0x2EA,
    ADDZE   = 0x0CA,
    ADDZEO  = 0x2CA,
    AND     = 0x01C,
    ANDC    = 0x03C,
    CMP     = 0x000,
    CMPL    = 0x020,
    CNTLZW  = 0x01A,
    DCBF    = 0x056,
    DCBI    = 0x1D6,
    DCBST   = 0x036,
    DIVW    = 0x1EB,
    DIVWO   = 0x3EB,
    DIVWU   = 0x1CB,
    DIVWUO  = 0x3CB,
    EQV     = 0x11c,
    EXTSB   = 0x3BA,
    EXTSH   = 0x39A,
    HLE     = 0x357,
    ICBI    = 0x3D6,
    LWZX    = 0x017,
    MFMSR   = 0x053,
    MFSPR   = 0x153,
    MFTB    = 0x173,
    MTMSR   = 0x092,
    MTSPR   = 0x1D3,
    MULLW   = 0x0EB,
    MULLWO  = 0x2EB,
    MULHW   = 0x04B,
    MULHWU  = 0x00B,
    NAND    = 0x1DC,
    NEG     = 0x068,
    NEGO    = 0x268,
    NOR     = 0x07C,
    OR      = 0x1BC,
    ORC     = 0x19C,
    SLW     = 0x018,
    SRAW    = 0x318,
    SRAWI   = 0x338,
    SRW     = 0x218,
    STWX    = 0x097,
    SUBF    = 0x028,
    SUBFO   = 0x228,
    SUBFC   = 0x008,
    SUBFCO  = 0x208,
    SUBFE   = 0x088,
    SUBFEO  = 0x288,
    SUBFME  = 0x0E8,
    SUBFMEO = 0x2E8,
    SUBFZE  = 0x0C8,
    SUBFZEO = 0x2C8,
    SYNC    = 0x256,
    XOR     = 0x13C,
}

enum PrimaryOp3BSecondaryOpcode {
    FNMSUBSX = 0x1E
}

enum PrimaryOp3FSecondaryOpcode {
    FABSX  = 0x108,
    FADDX  = 0x015,
    FDIVX  = 0x012,
    FMR    = 0x048,
    FMULX  = 0x019,
    FMSUBX = 0x01C,
    FNABSX = 0x088,
    FNEGX  = 0x028,
    FSEL   = 0x017,
    MTFSF  = 0x2C7
}