// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//
module dffe(q, d, clk, enable, reset);
output q;
reg    q;
input  d;
input  clk, enable, reset;

always@(reset)
if (reset == 1'b1)
q <= 0;

always@(posedge clk)
if ((reset == 1'b0) && (enable == 1'b1))
q <= d;
endmodule // dffe

//I = 00,11,00
//L = 00,11,01,00
//U = 11,01,11,00
//V = 10,01,10,00
module word_reader(I, L, U, V, bits, clk, reset);
output 	I, L, U, V;
input [1:0] 	bits;
input 	reset, clk;
wire         start, start_next, Vo, Vt, Vz, Vout, Io, Lo, Uo, Uout, Uout_next, Lout, Iout, Vo_next, V1_next, V2_next, Vout_next, Io_next, Lo_next, Uo_next, Lout_next, Iout_next, garbage, garbage_next;


assign start_next = ((start & (~bits[0] & ~bits[1])) | (Iout & (~bits[0] & ~bits[1])) | (Uout & (~bits[0] & ~bits[1])) | (Lout & (~bits[0] & ~bits[1])) |  (Vo & (~bits[0] & ~bits[1])) | (Vt & (~bits[0] & ~bits[1])) | (Vout & (~bits[0] & ~bits[1])) | (Uout & (~bits[0] & ~bits[1])) | (garbage & (~bits[0] & ~bits[1])))  | (reset);
assign Io_next = ((start & (bits[0] & bits[1]))) & (~reset);
assign Lo_next = ((Io & (bits[0] & ~bits[1]))) & (~reset);
assign Uo_next = ((Lo & (bits[0] & bits[1]))) & (~reset);
assign Uout_next = ((Uo & (~bits[0] & ~bits[1]))) & (~reset);
assign Lout_next = ((Lo & (~bits[0] & ~bits[1]))) & (~reset);
assign Iout_next = ((Io & (~bits[0] & ~bits[1]))) & (~reset);
assign Vo_next = ((start & (~bits[0] & bits[1]))) & (~reset);
assign V1_next = ((Vo & (bits[0] & ~bits[1]))) & (~reset);
assign V2_next = ((Vt & (~bits[0] & bits[1]))) & (~reset);
assign Vout_next = ((Vz & (~bits[0] & ~bits[1]))) & (~reset);
assign garbage_next = ((Io & (bits[0] & ~bits[1]) | (bits[0] & bits[1])) | (Lo & ((bits[0] & ~bits[1]) | (~bits[0] & bits[1]))) | (Uo & (((bits[0] & ~bits[1]) | (~bits[0] & bits[1])) | (bits[0] & bits[1]))) | (Vo & (((bits[0] & ~bits[1]) | (~bits[0] & bits[1])) | (bits[0] & bits[1]))) | (Vt & (bits[0] & bits[1]) | (~bits[0] & bits[1])) | (Vz & ((bits[0] & bits[1]) | (~bits[0] & bits[1]) | (bits[0] & ~bits[1]))) | (Vout & ((bits[0] & bits[1]) | (~bits[0] & bits[1]) | (bits[0] & ~bits[1]))) | (Uout & ((bits[0] & bits[1]) | (~bits[0] & bits[1]) | (bits[0] & ~bits[1]))) | (Lout & ((bits[0] & bits[1]) | (~bits[0] & bits[1]) | (bits[0] & ~bits[1]))) | (Iout & ((bits[0] & bits[1]) | (~bits[0] & bits[1]) | (bits[0] & ~bits[1])))) & (~reset);


dffe fsStart(start, start_next, clk, 1'b1, 1'b0);
dffe fsIo(Io, Io_next, clk, 1'b1, 1'b0);
dffe fsLo(Lo, Lo_next, clk, 1'b1, 1'b0);
dffe fsUo(Uo, Uo_next, clk, 1'b1, 1'b0);
dffe fsUout(Uout, Uout_next, clk, 1'b1, 1'b0);
dffe fsLout(Lout, Lout_next, clk, 1'b1, 1'b0);
dffe fsIout(Iout, Iout_next, clk, 1'b1, 1'b0);
dffe fsVo(Vo, Vo_next, clk, 1'b1, 1'b0);
dffe fsV1(Vt, V1_next, clk, 1'b1, 1'b0);
dffe fsV2(Vz, V2_next, clk, 1'b1, 1'b0);
dffe fsVout(Vout, Vout_next, clk, 1'b1, 1'b0);
dffe fsgarbage(garbage,garbage_next, clk, 1'b1, 1'b0);


assign I = Iout;
assign L = Lout;
assign U = Uout;
assign V = Vout;

// | other condition ...

//diffe fsS1(sNuLL, sNull, clk, 1'b0, 1'b0);

endmodule // word_reader
