// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

	wire [31:0] inst;
    wire [31:0] PC;

    wire [31:0] nextPC, PCplusfour, branchOut, branchOffset, rsData, jump, imm, luiConnect, memReadout, rdData, B, rtData, out, sltout, dataOut, byte_load_connect, byteout, new_negative, Bout, rdDatafinal;
    wire [4:0] Rdest;
    wire [2:0] alu_op;
    wire [1:0] control_type;
    wire rd_src, wr_enable, alu_src2, word_we, byte_we, byte_load, lui, slt, zero, mem_read, overflow, negative, addm;


	assign jump[31:28] = PC[31:28];
	assign jump[27:2] = inst[25:0];
    assign jump[1:0] = 0;
    assign luiConnect[31:16] = inst[15:0];
    assign luiConnect[15:0] = 0;
    assign byte_load_connect[31:8] = 0;
    assign new_negative[0] = negative;
    assign new_negative[31:1] = 0;



    register #(32) PC_reg(PC[31:0], nextPC[31:0], clock, 1'b1, reset);
	instruction_memory im(inst[31:0], PC[31:2]);
	mips_decode m1(alu_op[2:0], wr_enable, rd_src, alu_src2, except, control_type[1:0], mem_read, word_we, byte_we, byte_load, lui, slt, addm, inst[31:26], inst[5:0], zero);
	data_mem dm1(dataOut[31:0], out[31:0], rtData[31:0], word_we, byte_we, clock, reset);
    regfile rf (rsData[31:0], rtData[31:0], inst[25:21], inst[20:16], Rdest[4:0], rdData[31:0], wr_enable, clock, reset);

	alu32 a1(PCplusfour[31:0], , , , PC[31:0], 32'h4, `ALU_ADD);
	alu32 a2(branchOut[31:0], , , , PCplusfour[31:0], branchOffset[31:0], `ALU_ADD);
	alu32 aludatamem(out[31:0], overflow, zero, negative, rsData[31:0], B[31:0], alu_op[2:0]);



	mux2v maddm_B(B[31:0], Bout[31:0], 32'b0, addm);
	mux2v maddm(rdData[31:0], rdDatafinal[31:0], rtData[31:0], addm);
	mux2v #(5) mrd_src(Rdest[4:0], inst[15:11], inst[20:16], rd_src);
	mux2v #(32) mlui(rdDatafinal[31:0], memReadout[31:0], luiConnect[31:0], lui);
	mux2v #(32) mslt(sltout[31:0], out[31:0], new_negative, slt);
	mux2v #(32) mmemread(memReadout[31:0], sltout[31:0], byteout[31:0], mem_read);
	mux2v #(32) mbyteld(byteout[31:0], dataOut[31:0], byte_load_connect[31:0], byte_load);
	mux2v #(32) malusrc2(Bout[31:0], rtData[31:0], imm[31:0], alu_src2);



	mux4v mcontrol(nextPC[31:0], PCplusfour[31:0], branchOut[31:0], jump, rsData, control_type);
	mux4v #(8) mdataout(byte_load_connect[7:0], dataOut[7:0], dataOut[15:8], dataOut[23:16], dataOut[31:24], out[1:0]);



	shift_left_two sl1(branchOffset, imm[29:0]);
	sign_extender s1(imm, inst[15:0]);
    /* add other modules */

endmodule // full_machine

module sign_extender (imm, inst);
    output [31:0] imm;
    input [15:0] inst;
    assign imm = {{16{inst[15]}}, inst[15:0]};

endmodule // sign_extender

module shift_left_two (branchOffset, imm);
   output [31:0] branchOffset;
   input [29:0] imm;
   assign branchOffset[31:2] = imm[29:0];
   assign branchOffset[1:0] = 0;

endmodule // shift_left_two
