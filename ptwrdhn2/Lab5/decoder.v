// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;
		wire op_add, op_sub, op_and, op_or, op_nor, op_xor, op_addi, op_andi, op_ori, op_xori;

    assign op_add = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
    assign op_sub = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);
    assign op_and = (opcode == `OP_OTHER0) & (funct == `OP0_AND);
    assign op_or = (opcode == `OP_OTHER0) & (funct == `OP0_OR);
    assign op_nor = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);
    assign op_xor = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);
    assign op_addi = (opcode == `OP_ADDI);
    assign op_andi = (opcode == `OP_ANDI);
    assign op_ori = (opcode == `OP_ORI);
    assign op_xori = (opcode == `OP_XORI);
    assign rd_src = (op_addi | op_andi | op_ori | op_xori);
    assign alu_src2 = (op_addi | op_andi | op_ori | op_xori);
    assign except = ~(op_add | op_sub | op_and | op_or | op_nor | op_xor |
             op_addi | op_andi | op_ori | op_xori);
    assign writeenable = ~except;
    assign alu_op[0] = (op_sub | op_or | op_xor | op_ori | op_xori);
    assign alu_op[1] = (op_add | op_sub| op_nor | op_xor | op_addi | op_xori);
    assign alu_op[2] = (op_and | op_or | op_nor | op_xor | op_andi | op_ori | op_xori);
		// assign alu_src2 = ~funct[5];
		// assign rd_src = ~funct[5];
		// assign except = 0;
		// assign writeenable = ~except;
		// assign alu_op[2] = funct[2] || opcode[2];
		// assign alu_op[1] = 1'b0;
		// assign alu_op[0] = 1'b0;

endmodule // mips_decode
