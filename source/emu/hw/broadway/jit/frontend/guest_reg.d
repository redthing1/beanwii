module emu.hw.broadway.jit.frontend.guest_reg;

import std.conv;
import std.uni;

enum GuestReg {
    R0,  R1,  R2,  R3,  R4,  R5,  R6,  R7,  R8,  R9,  R10, R11, R12, R13, R14, R15,
    R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31,

    F0,  F1,  F2,  F3,  F4,  F5,  F6,  F7,  F8,  F9,  F10, F11, F12, F13, F14, F15,
    F16, F17, F18, F19, F20, F21, F22, F23, F24, F25, F26, F27, F28, F29, F30, F31,

    PS0,  PS1,  PS2,  PS3,  PS4,  PS5,  PS6,  PS7,  PS8,  PS9,  PS10, PS11, PS12, PS13, PS14, PS15,
    PS16, PS17, PS18, PS19, PS20, PS21, PS22, PS23, PS24, PS25, PS26, PS27, PS28, PS29, PS30, PS31,

    CR,
    XER,
    CTR,
    MSR,

    GQR0, GQR1, GQR2, GQR3, GQR4, GQR5, GQR6, GQR7,

    SRR0,
    FPSR,
    FPSCR,

    L2CR,

    HID0,
    HID2,

    TBL,
    TBU,

    LR,
    PC,
}

public GuestReg to_gpr(int reg) {
    return cast(GuestReg) reg + GuestReg.R0;
}

public GuestReg to_fpr(int reg) {
    return cast(GuestReg) reg + GuestReg.F0;
}

public GuestReg to_gqr(int reg) {
    return cast(GuestReg) reg + GuestReg.GQR0;
}

public GuestReg to_ps(int reg) {
    return cast(GuestReg) reg + GuestReg.PS0;
}

public string to_string(GuestReg reg) {
    return std.conv.to!string(reg).toLower();
}

public size_t get_reg_offset(GuestReg reg) {
    import emu.hw.broadway.state;

    switch (reg) {
        case GuestReg.R0:   .. case GuestReg.R31:  return BroadwayState.gprs.offsetof + (reg - GuestReg.R0) * 4;
        case GuestReg.F0:   .. case GuestReg.F31:  return BroadwayState.fprs.offsetof + (reg - GuestReg.F0) * 8;
        case GuestReg.PS0:  .. case GuestReg.PS31: return BroadwayState.fprs.offsetof + (reg - GuestReg.PS0) * 8;
        case GuestReg.GQR0: .. case GuestReg.GQR7: return BroadwayState.gqrs.offsetof + (reg - GuestReg.GQR0) * 4;
    
        case GuestReg.CR:    return BroadwayState.cr.offsetof;
        case GuestReg.XER:   return BroadwayState.xer.offsetof;
        case GuestReg.CTR:   return BroadwayState.ctr.offsetof;
        case GuestReg.MSR:   return BroadwayState.msr.offsetof;
        case GuestReg.HID0:  return BroadwayState.hid0.offsetof;
        case GuestReg.HID2:  return BroadwayState.hid2.offsetof;
        case GuestReg.SRR0:  return BroadwayState.srr0.offsetof;
        case GuestReg.FPSR:  return BroadwayState.fpsr.offsetof;
        case GuestReg.FPSCR: return BroadwayState.fpscr.offsetof;
        case GuestReg.L2CR:  return BroadwayState.l2cr.offsetof;
        case GuestReg.LR:    return BroadwayState.lr.offsetof;
        case GuestReg.PC:    return BroadwayState.pc.offsetof;

        default: assert(0);
    }
}
