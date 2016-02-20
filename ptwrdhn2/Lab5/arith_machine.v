// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;
    wire [31:0] PC;
	wire [31:0] PC_next;
	wire [31:0] rdData;
	wire [31:0] B;
	wire [4:0]  Rdest;
	wire [31:0] rtData;
	wire [31:0] rsData;
	wire [31:0] imm32;
	wire [2:0]  alu_op;
	wire 		writeenable;
	wire 		rd_src;
	wire 		alu_src2;
	wire 		overflow, zero, negative;
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, PC_next, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst[31:0], PC[31:2]);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], Rdest, rdData, writeenable, clock, reset);

	alu32 a1(PC_next, , , , PC, 32'h4, `ALU_ADD);
	alu32 a2(rdData, overflow, zero, negative, rsData, B, alu_op);
	mux2v #(5) m1(Rdest, inst[15:11], inst[20:16], rd_src);
	mux2v m2(B, rtData, imm32, alu_src2);
	sign_extender s1(imm32, inst[15:0]);
	mips_decode md1(alu_op, writeenable, rd_src, alu_src2, except, inst[31:26], inst[5:0]);

    /* add other modules */

endmodule // arith_machine

module sign_extender (imm, inst);
    output [31:0] imm;
    input [15:0] inst;
    assign imm = {{16{inst[15]}}, inst[15:0]};

endmodule
