module word_reader_test;

reg reset = 1;
reg [1:0] bits = 2'b0;
reg clk = 0;
always #5 clk = !clk;

initial begin

	$dumpfile("wr.vcd");
	$dumpvars(0, word_reader_test);

	# 12
	reset = 0;
	# 20
	bits = 2'b00;     // I
	# 10
	bits = 2'b11;
	# 10
	bits = 2'b00;
	# 10
	bits = 2'b00;
	# 10
	bits = 2'b11;
	# 10
	bits = 2'b01;
	# 10
	bits = 2'b00;
	# 10
	bits = 2'b11;
	# 10
	bits = 2'b01;
	# 10
	bits = 2'b11;
	# 10
	bits = 2'b00;
	# 10
	bits = 2'b10;
	# 10
	bits = 2'b01;
	# 10
	bits = 2'b10;
	# 10
	bits = 2'b00;
	# 10
	bits = 2'b00;
	# 10
	bits = 2'b11;
	# 10
	bits = 2'b01;
	# 10
	bits = 2'b11;
	# 10
	bits = 2'b00;
	# 10
	bits = 2'b00;
	# 30
	$finish;              // end the simulation
end

wire I, L, U, V;
word_reader wr(I, L, U, V, bits, clk, reset);

initial
$monitor("At time %t, bits = %b I = %d L = %d U = %d V = %d reset = %x",
$time, bits, I, L, U, V, reset);
endmodule // word_reader_test
