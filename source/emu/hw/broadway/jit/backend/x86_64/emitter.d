module emu.hw.broadway.jit.backend.x86_64.emitter;

import emu.hw.broadway.jit.backend.x86_64.host_reg;
import emu.hw.broadway.jit.backend.x86_64.register_allocator;
import emu.hw.broadway.jit.frontend.guest_reg;
import emu.hw.broadway.jit.ir.ir;
import emu.hw.broadway.jit.ir.types;
import emu.hw.broadway.state;
import std.sumtype;
import util.log;
import xbyak;

final class Code : CodeGenerator {
    RegisterAllocator register_allocator;

    this() {
        register_allocator = new RegisterAllocator();
    }

    void disambiguate_second_operand_and_emit(string op)(Reg reg, IROperand operand) {
        // static if (T == operand)

        // ir_operand.match!(
        //     (_IRVariable ir_variable) => ir_variable,

        //     (_IRConstant ir_constant) {
        //         error_jit("Tried to get variable from constant");
        //         return _IRVariable(-1);
        //     },

        //     (_IRGuestReg ir_guest_reg) {
        //         error_jit("Tried to get variable from guest register");
        //         return _IRVariable(-1);
        //     }
        // );
    }

    override void reset() {
        super.reset();
        
        if (register_allocator) register_allocator.reset();
    }

    void emit(IR* ir) {
        emit_prologue();

        ir.pretty_print();

        for (int i = 0; i < ir.length(); i++) {
            emit(ir.instructions[i], i);
        }

        emit_epilogue();
    }

    void emit_prologue() {
        push(rbp);
        mov(rbp, rsp);
        
        push(rbx);
        push(rsi);
        push(rdi);
        push(r8);
        push(r9);
        push(r10);
        push(r11);
        push(r12);
        push(r13);
        push(r14);
        push(r15);
    }

    void emit_epilogue() {
        pop(r15);
        pop(r14);
        pop(r13);
        pop(r12);
        pop(r11);
        pop(r10);
        pop(r9);
        pop(r8);
        pop(rdi);
        pop(rsi);
        pop(rbx);

        pop(rbp);

        ret();
    }

    void emit_GET_REG(IRInstructionGetReg ir_instruction, int current_instruction_index) {
        GuestReg guest_reg = ir_instruction.src;
        HostReg_x86_64 host_reg = register_allocator.get_bound_host_reg(ir_instruction.dest);

        int offset = cast(int) BroadwayState.gprs.offsetof + 4 * guest_reg;
        mov(host_reg.to_xbyak_reg32(), dword [rdi + offset]);
    }

    void emit_SET_REG_VAR(IRInstructionSetRegVar ir_instruction, int current_instruction_index) {
        GuestReg dest_reg = ir_instruction.dest;
        Reg src_reg = register_allocator.get_bound_host_reg(ir_instruction.src).to_xbyak_reg32();
        
        int offset = cast(int) BroadwayState.gprs.offsetof + 4 * dest_reg;
        mov(dword [rdi + offset], src_reg);

        register_allocator.maybe_unbind_variable(ir_instruction.src, current_instruction_index);
    }

    void emit_SET_REG_IMM(IRInstructionSetRegImm ir_instruction, int current_instruction_index) {
        GuestReg dest_reg = ir_instruction.dest;
        
        int offset = cast(int) BroadwayState.gprs.offsetof + 4 * dest_reg;
        mov(dword [rdi + offset], ir_instruction.imm);
    }

    void emit_BINARY_DATA_OP_IMM(IRInstructionBinaryDataOpImm ir_instruction, int current_instruction_index) {
        Reg dest_reg = register_allocator.get_bound_host_reg(ir_instruction.dest).to_xbyak_reg32();
        Reg src1     = register_allocator.get_bound_host_reg(ir_instruction.src1).to_xbyak_reg32();
        int src2     = ir_instruction.src2;
        
        switch (ir_instruction.op) {
            case IRBinaryDataOp.AND:
                mov(dest_reg, src1);
                and(dest_reg, src2);
                break;
            
            case IRBinaryDataOp.ORR:
                mov(dest_reg, src1);
                or (dest_reg, src2);
                break;
            
            case IRBinaryDataOp.LSL:
                mov(dest_reg, src1);
                shl(dest_reg, src2);
                break;
            
            case IRBinaryDataOp.ADD:
                mov(dest_reg, src1);
                add(dest_reg, src2);
                break;
            
            case IRBinaryDataOp.SUB:
                mov(dest_reg, src1);
                sub(dest_reg, src2);
                break;
            
            case IRBinaryDataOp.XOR:
                mov(dest_reg, src1);
                xor(dest_reg, src2);
                break;
            
            case IRBinaryDataOp.ROL:
                mov(dest_reg, src1);
                rol(dest_reg, src2);
                break;
            
            default: break;
        }
        
        register_allocator.maybe_unbind_variable(ir_instruction.dest, current_instruction_index);
        register_allocator.maybe_unbind_variable(ir_instruction.src1, current_instruction_index);
    }

    void emit_BINARY_DATA_OP_VAR(IRInstructionBinaryDataOpVar ir_instruction, int current_instruction_index) {
        Reg dest_reg        = register_allocator.get_bound_host_reg(ir_instruction.dest).to_xbyak_reg32();
        Reg src1            = register_allocator.get_bound_host_reg(ir_instruction.src1).to_xbyak_reg32();
        HostReg_x86_64 src2 = register_allocator.get_bound_host_reg(ir_instruction.src2);
        
        switch (ir_instruction.op) {
            case IRBinaryDataOp.AND:
                mov(dest_reg, src1);
                and(dest_reg, src2.to_xbyak_reg32());
                break;
            
            case IRBinaryDataOp.ORR:
                mov(dest_reg, src1);
                or (dest_reg, src2.to_xbyak_reg32());
                break;
            
            case IRBinaryDataOp.LSL:
                mov(dest_reg, src1);
                shl(dest_reg, src2.to_xbyak_reg8());
                break;
            
            case IRBinaryDataOp.ADD:
                mov(dest_reg, src1);
                add(dest_reg, src2.to_xbyak_reg32());
                break;
            
            case IRBinaryDataOp.SUB:
                mov(dest_reg, src1);
                sub(dest_reg, src2.to_xbyak_reg32());
                break;
            
            case IRBinaryDataOp.XOR:
                mov(dest_reg, src1);
                xor(dest_reg, src2.to_xbyak_reg32());
                break;
            
            case IRBinaryDataOp.ROL:
                mov(dest_reg, src1);
                rol(dest_reg, src2.to_xbyak_reg8());
                break;
            
            default: break;
        }

        register_allocator.maybe_unbind_variable(ir_instruction.dest, current_instruction_index);
        register_allocator.maybe_unbind_variable(ir_instruction.src1, current_instruction_index);
        register_allocator.maybe_unbind_variable(ir_instruction.src2, current_instruction_index);
    }

    void emit_UNARY_DATA_OP(IRInstructionUnaryDataOp ir_instruction, int current_instruction_index) {
        Reg dest_reg = register_allocator.get_bound_host_reg(ir_instruction.dest).to_xbyak_reg32();
        Reg src_reg  = register_allocator.get_bound_host_reg(ir_instruction.src).to_xbyak_reg32();

        bool unbound_src = false;

        switch (ir_instruction.op) {
            case IRUnaryDataOp.NOT:
                mov(dest_reg, src_reg);
                not(dest_reg);
                break;

            case IRUnaryDataOp.NEG:
                mov(dest_reg, src_reg);
                neg(dest_reg);
                break;
            
            case IRUnaryDataOp.MOV:
                // if src_reg is going to be unbound after this instruction, then we can just bind
                // dest_reg to src_reg's host register and save a mov

                if (register_allocator.will_variable_be_unbound(ir_instruction.src, current_instruction_index)) {
                    auto src_host_reg = register_allocator.get_bound_host_reg(ir_instruction.src);
                    register_allocator.unbind_host_reg(src_host_reg);
                    register_allocator.bind_variable_to_host_reg(ir_instruction.dest, src_host_reg);
                    unbound_src = true;
                } else {
                    mov(dest_reg, src_reg);
                }
                break;

            default: break;
        }

        register_allocator.maybe_unbind_variable(ir_instruction.dest, current_instruction_index);
        
        if (!unbound_src) {
            register_allocator.maybe_unbind_variable(ir_instruction.src,  current_instruction_index);
        }
    }

    void emit_SET_FLAGS(IRInstructionSetFlags ir_instruction, int current_instruction_index) {
        log_jit("emitting set_flags");
    }

    void emit(IRInstruction ir_instruction, int current_instruction_index) {
        ir_instruction.match!(
            (IRInstructionGetReg i)          => emit_GET_REG(i, current_instruction_index),
            (IRInstructionSetRegVar i)       => emit_SET_REG_VAR(i, current_instruction_index),
            (IRInstructionSetRegImm i)       => emit_SET_REG_IMM(i, current_instruction_index),
            (IRInstructionBinaryDataOpImm i) => emit_BINARY_DATA_OP_IMM(i, current_instruction_index),
            (IRInstructionBinaryDataOpVar i) => emit_BINARY_DATA_OP_VAR(i, current_instruction_index),
            (IRInstructionUnaryDataOp i)     => emit_UNARY_DATA_OP(i, current_instruction_index),
            (IRInstructionSetFlags i)        => emit_SET_FLAGS(i, current_instruction_index),
        );
    }

    void pretty_print() {
        import capstone;

        auto disassembler = create(Arch.x86, ModeFlags(Mode.bit64 | Mode.littleEndian));
        auto instructions = disassembler.disasm(this.getCode()[0..this.getSize()], this.getSize());
        foreach (instruction; instructions) {
            log_xbyak("0x%x:\t%s\t\t%s", instruction.address, instruction.mnemonic, instruction.opStr);
        }
    }
}