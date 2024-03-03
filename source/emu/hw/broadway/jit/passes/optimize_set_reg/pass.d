module emu.hw.broadway.jit.passes.optimize_set_reg.pass;

import emu.hw.broadway.jit.common.guest_reg;
import emu.hw.broadway.jit.ir.instruction;
import emu.hw.broadway.jit.ir.recipe;
import emu.hw.broadway.jit.ir.types;
import std.sumtype;

final class OptimizeSetReg : RecipePass {
    final class Map : RecipeMap {
        bool[GuestReg] seen_regs;

        override public RecipeAction map(Recipe recipe, IRInstruction* instr) {
            return (*instr).match!(
                (IRInstructionSetReg i) {
                    if (i.dest.is_write_volatile()) {
                        return RecipeAction.DoNothing();
                    }

                    if (i.dest in seen_regs) {
                        return RecipeAction.Remove();
                    }

                    seen_regs[i.dest] = true;
                    return RecipeAction.DoNothing();
                },

                _ => RecipeAction.DoNothing()
            );        
        }
    }

    override public void pass(Recipe recipe) {
        recipe.reverse_map(new Map());
    }
}
