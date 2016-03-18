`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           regnum, wr_data, next_pc, TimerInterrupt,
           MTC0, ERET, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input   [4:0] regnum;
    input  [31:0] wr_data;
    input  [29:0] next_pc;
    input         TimerInterrupt, MTC0, ERET, clock, reset;

	wire   [29:0] Q, d_epc;
	wire   [31:0] mtc0_out, status_register, cause_register, user_status;
	wire          exception_level;

	assign status_register[31:16] = 0;
	assign status_register[15] =  user_status[15];
	assign status_register[14] =  user_status[14];
	assign status_register[13] =  user_status[13];
	assign status_register[12] =  user_status[12];
	assign status_register[11] =  user_status[11];
	assign status_register[10] =  user_status[10];
	assign status_register[9] =  user_status[9];
	assign status_register[8] =  user_status[8];
	assign status_register[7:2] = 0;
	assign status_register[1] = exception_level;
	assign status_register[0] = user_status[0];

	assign cause_register[31:16] = 0;
	assign cause_register[15] = TimerInterrupt;
	assign cause_register[14:0] = 0;
	assign EPC = Q;
	// assign rd_data = 32'b0;



    // your Verilog for coprocessor 0 goes here

	decoder32 mtc0(mtc0_out, regnum, MTC0);

	mux32v #(32) rd_out(rd_data, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, status_register, cause_register, {Q[29:0], 2'b0}, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, regnum);

	dffe dffe_exception_level(exception_level, 1'b1, clock, TakenInterrupt, reset || ERET);

	register reg_user_status(user_status, wr_data, clock, (mtc0_out[12] && (regnum == `STATUS_REGISTER)), reset);

	mux2v #(30) data_or_next(d_epc, wr_data[31:2], next_pc, TakenInterrupt);

	register #(30) epc(Q, d_epc, clock, TakenInterrupt || mtc0_out[14], reset);

	assign TakenInterrupt = ((cause_register[15] && status_register[15]) && (!status_register[1] && status_register[0]));


endmodule
