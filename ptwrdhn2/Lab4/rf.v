// register: A register which may be reset to an arbirary value
//
// q      (output) - Current value of register
// d      (input)  - Next value of register
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset    (reset = 1)
//
module register(q, d, clk, enable, reset);

    parameter
        width = 32,
        reset_value = 0;

    output [(width-1):0] q;
    reg    [(width-1):0] q;
    input  [(width-1):0] d;
    input                clk, enable, reset;

    always@(reset)
      if (reset == 1'b1)
        q <= reset_value;

    always@(posedge clk)
      if ((reset == 1'b0) && (enable == 1'b1))
        q <= d;

endmodule // register

module decoder2 (out, in, enable);
    input     in;
    input     enable;
    output [1:0] out;

    and a0(out[0], enable, ~in);
    and a1(out[1], enable, in);
endmodule // decoder2

module decoder4 (out, in, enable);
    input [1:0]    in;
    input     enable;
    output [3:0]   out;
    wire [1:0]    w_enable;

		decoder2 d2_in(w_enable[1:0], in[1], enable);
		decoder2 d2_1(out[3:2], in[0], w_enable[1]);
    decoder2 d2_2(out[1:0], in[0], w_enable[0]);



    // implement using decoder2's

endmodule // decoder4

module decoder8 (out, in, enable);
    input [2:0]    in;
    input     enable;
    output [7:0]   out;
    wire [1:0]    w_enable;

    // implement using decoder2's and decoder4's
		decoder2 d2_in(w_enable[1:0], in[2], enable);
		decoder4 d4_1(out[7:4], in[1:0], w_enable[1]);
		decoder4 d4_2(out[3:0], in[1:0], w_enable[0]);

endmodule // decoder8

module decoder16 (out, in, enable);
    input [3:0]    in;
    input     enable;
    output [15:0]  out;
    wire [1:0]    w_enable;

    // implement using decoder2's and decoder8's
		decoder2 d2_in(w_enable[1:0], in[3], enable);
		decoder8 d8_1(out[15:8], in[2:0], w_enable[1]);
		decoder8 d8_2(out[7:0], in[2:0], w_enable[0]);

endmodule // decoder16

module decoder32 (out, in, enable);
    input [4:0]    in;
    input     enable;
    output [31:0]  out;
    wire [1:0]    w_enable;

    // implement using decoder2's and decoder16's
		decoder2 d2_in(w_enable[1:0], in[4], enable);
		decoder16 d16_1(out[31:16], in[3:0], w_enable[1]);
		decoder16 d16_2(out[15:0], in[3:0], w_enable[0]);

endmodule // decoder32

module mips_regfile (rd1_data, rd2_data, rd1_regnum, rd2_regnum,
             wr_regnum, wr_data, writeenable,
             clock, reset);

    output [31:0]  rd1_data, rd2_data;
    input   [4:0]  rd1_regnum, rd2_regnum, wr_regnum;
    input  [31:0]  wr_data;
    input          writeenable, clock, reset;
		wire 	 [31:0]	 pick, q[0:31];

		decoder32 d0(pick, wr_regnum, writeenable);
    // build a register file!
		register r0(q[0], 32'b0, clock, pick[0], reset);
     register r1(q[1], wr_data, clock, pick[1], reset);
     register r2(q[2], wr_data, clock, pick[2], reset);
     register r3(q[3], wr_data, clock, pick[3], reset);
     register r4(q[4], wr_data, clock, pick[4], reset);
     register r5(q[5], wr_data, clock, pick[5], reset);
     register r6(q[6], wr_data, clock, pick[6], reset);
     register r7(q[7], wr_data, clock, pick[7], reset);
     register r8(q[8], wr_data, clock, pick[8], reset);
     register r9(q[9], wr_data, clock, pick[9], reset);
     register r10(q[10], wr_data, clock, pick[10], reset);
     register r11(q[11], wr_data, clock, pick[11], reset);
     register r12(q[12], wr_data, clock, pick[12], reset);
     register r13(q[13], wr_data, clock, pick[13], reset);
     register r14(q[14], wr_data, clock, pick[14], reset);
     register r15(q[15], wr_data, clock, pick[15], reset);
     register r16(q[16], wr_data, clock, pick[16], reset);
     register r17(q[17], wr_data, clock, pick[17], reset);
     register r18(q[18], wr_data, clock, pick[18], reset);
     register r19(q[19], wr_data, clock, pick[19], reset);
     register r20(q[20], wr_data, clock, pick[20], reset);
     register r21(q[21], wr_data, clock, pick[21], reset);
     register r22(q[22], wr_data, clock, pick[22], reset);
     register r23(q[23], wr_data, clock, pick[23], reset);
     register r24(q[24], wr_data, clock, pick[24], reset);
     register r25(q[25], wr_data, clock, pick[25], reset);
     register r26(q[26], wr_data, clock, pick[26], reset);
     register r27(q[27], wr_data, clock, pick[27], reset);
     register r28(q[28], wr_data, clock, pick[28], reset);
     register r29(q[29], wr_data, clock, pick[29], reset);
     register r30(q[30], wr_data, clock, pick[30], reset);

		 mux32v m1(rd1_data, q[0], q[1], q[2], q[3], q[4], q[5], q[6], q[7], q[8],
     q[9], q[10], q[11], q[12], q[13], q[14], q[15], q[16], q[17], q[18], q[19],
     q[20], q[21], q[22], q[23], q[24], q[25], q[26], q[27], q[28], q[29], q[30],
     q[31], rd1_regnum);

		 mux32v m2(rd2_data, q[0], q[1], q[2], q[3], q[4], q[5], q[6], q[7], q[8],
 		q[9], q[10], q[11], q[12], q[13], q[14], q[15], q[16], q[17], q[18], q[19],
 		q[20], q[21], q[22], q[23], q[24], q[25], q[26], q[27], q[28], q[29], q[30],
 		q[31], rd2_regnum);

endmodule // mips_regfile
