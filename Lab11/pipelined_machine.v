module pipelined_machine(clk, reset);
	input        clk, reset;

	wire [31:0]  PC;
	wire [31:2]  next_PC, PC_plus4, PC_plus4_old, PC_target;
	wire [31:0]  inst, inst_pre_pipe;

	wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
	wire [4:0]   rs = inst[25:21];
	wire [4:0]   rt = inst[20:16];
	wire [4:0]   rd = inst[15:11];
	wire [5:0]   opcode = inst[31:26];
	wire [5:0]   funct = inst[5:0];

	wire [4:0]   wr_regnum, wr_regnum_MW;
	wire [2:0]   ALUOp, ALUOp_MW;

	wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
	wire         RegWrite_MW, BEQ_MW, ALUSrc_MW, MemRead_MW, MemWrite_MW, MemToReg_MW, RegDst_MW, ForwardA, ForwardB;
	wire         PCSrc, zero;
	wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;
	wire [31:0]  rd1_data_old, rd2_data_MW, rd2_data_old, B_data_old, alu_out_data_MW;

	assign ForwardA = ((rs == wr_regnum_MW) && RegWrite_MW && (rs != 0));
	assign ForwardB = ((rt == wr_regnum_MW) && RegWrite_MW && (rt != 0));

	assign Stall = ((wr_regnum_MW == rs && rs != 0) || (wr_regnum_MW == rt && rt != 0)) && (MemRead_MW);

	register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~Stall, reset);
	assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
	adder30 next_PC_adder(PC_plus4_old, PC[31:2], 30'h1);
	adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
	mux2v #(30) branch_mux(next_PC, PC_plus4_old, PC_target, PCSrc);
	assign PCSrc = BEQ & zero;

	instruction_memory imem (inst_pre_pipe, PC[31:2]);
	register #(32) if_de_imem(inst, inst_pre_pipe, clk, ~Stall, reset);
	register #(30) if_de_pcplusfour(PC_plus4, PC_plus4_old, clk, ~Stall, reset);

	mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, opcode, funct);
	register #(3) aluop_mw(ALUOp_MW, ALUOp, clk, ~Stall, reset);
	register #(1) regwrite_mw(RegWrite_MW, RegWrite, clk, ~Stall, reset);
	register #(1) beq_mw(BEQ_MW, BEQ, clk, ~Stall, reset);
	register #(1) alusrc_mw(ALUSrc_MW, ALUSrc, clk, ~Stall, reset);
	register #(1) memread_mw(MemRead_MW, MemRead, clk, ~Stall, reset);
	register #(1) memwrite_mw(MemWrite_MW, MemWrite, clk, ~Stall, reset);
	register #(1) memtoreg_mw(MemToReg_MW, MemToReg, clk, ~Stall, reset);
	register #(1) regdst_mw(RegDst_MW, RegDst, clk, ~Stall, reset);

	regfile rf (rd1_data_old, rd2_data, rs, rt, wr_regnum_MW, wr_data, RegWrite_MW, clk, reset);

	mux2v #(32) imm_mux(B_data, rd2_data_old, imm, ALUSrc);
	alu32 alu(alu_out_data, zero, ALUOp, rd1_data, B_data);

	data_mem data_memory(load_data, alu_out_data_MW, rd2_data_MW, MemRead_MW, MemWrite_MW, clk, reset);

	mux2v #(32) wb_mux(wr_data, alu_out_data_MW, load_data, MemToReg_MW);
	mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);


	mux2v #(32) forwarda_mux(rd1_data, rd1_data_old, alu_out_data_MW, ForwardA);
	mux2v #(32) forwardb_mux(rd2_data_old, rd2_data, alu_out_data_MW, ForwardB);

	register #(5) de_mw_regnum(wr_regnum_MW, wr_regnum, clk, 1'b1, reset);
	register #(32) de_mw_forwardB(rd2_data_MW, rd2_data_old, clk, 1'b1, reset);
	register #(32) de_mw_aluresult(alu_out_data_MW, alu_out_data, clk, 1'b1, reset);

endmodule // pipelined_machine
