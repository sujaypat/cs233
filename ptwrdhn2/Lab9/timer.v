module timer(TimerInterrupt, TimerAddress, cycle,
             address, data, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt, TimerAddress;
    output [31:0] cycle;
    input  [31:0] address, data;
    input         MemRead, MemWrite, clock, reset;

	wire [31:0]   Qcyc, Dcyc, Qint, Dint;
	wire 		  Qline;


	wire one_c_equals_address = (32'hffff001c == address);
	wire six_c_equals_address = (32'hffff006c == address);


	wire TimerWrite = MemWrite && one_c_equals_address;
	wire TimerRead = MemRead && one_c_equals_address;
	wire Acknowledge = MemWrite && six_c_equals_address;

	assign TimerAddress = (one_c_equals_address || six_c_equals_address);
	assign TimerInterrupt = Qline;

    // complete the timer circuit here

	register #(32) cycle_counter(Qcyc, Dcyc, clock, 1'b1, reset);

	alu32 a1(Dcyc, , , `ALU_ADD, Qcyc, 32'b1);

	register #(32, 32'hffffffff) interrupt_cycle(Qint, Dint, clock, TimerWrite, reset);

	dffe #(1) interrupt_line(Qline, 1'b1, clock, (Qcyc == Qint), Acknowledge || reset);

	tristate same(cycle, Qcyc, TimerRead);

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
endmodule
