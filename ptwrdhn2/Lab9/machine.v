module machine(clk, reset);
	input        clk, reset;

	wire [31:0]  PC;
	wire [31:2]  next_PC, PC_plus4, PC_target, next_PC_new;
	wire [31:0]  inst;

	wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
	wire [4:0]   rs = inst[25:21];
	wire [4:0]   rt = inst[20:16];
	wire [4:0]   rd = inst[15:11];

	wire [4:0]   wr_regnum;
	wire [2:0]   ALUOp;

	wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET;
	wire         PCSrc, zero, negative, NotIO, TakenInterrupt, TimerAddress, TimerInterrupt;
	wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data, cycle, address, data, c0_rd_data;
	wire [31:2]  EPC, interrupt_taken;


	register #(30, 30'h100000) PC_reg(PC[31:2], next_PC_new[31:2], clk, /* enable */1'b1, reset);
	assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
	adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
	adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
	mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
	assign PCSrc = BEQ & zero;
	assign NotIO = ~TimerAddress;

	mux2v #(30) eret_mux(interrupt_taken, next_PC, EPC, ERET);

	mux2v #(30) taken_interrupt_mux(next_PC_new, interrupt_taken, 30'h80000180, TakenInterrupt);

	timer tim(TimerInterrupt, TimerAddress, cycle, address, data, MemRead, MemWrite, clk, reset);

	cp0 copro0(c0_rd_data, EPC, TakenInterrupt, wr_regnum, wr_data, next_PC, TimerInterrupt, MTC0, ERET, clk, reset);

	instruction_memory imem (inst, PC[31:2]);

	mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, MFC0, MTC0, ERET, inst);

	regfile rf (rd1_data, rd2_data, rs, rt, wr_regnum, wr_data, RegWrite, clk, reset);


	mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
	alu32 alu(alu_out_data, zero, negative, ALUOp, rd1_data, B_data);

	data_mem data_memory(load_data, alu_out_data, rd2_data, MemRead && NotIO, MemWrite && NotIO, clk, reset);

	mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);
	mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

endmodule // machine
