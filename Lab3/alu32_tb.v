module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        // add more test cases here!
        # 10 A = 2147483647; B = 2147483647; control = `ALU_ADD; // try adding max int
        # 10 A = -2147483648; B = -2147483648; control = `ALU_SUB; // try subtracting max int

	# 10 A = 2147483632; B = 36; control = `ALU_SUB; // sub large number
        # 10 A =  32'h7FFFFFFF; B = 1; control = `ALU_ADD;
        //logic tests
        # 10 A = 1; B = 1; control = `ALU_AND;
        # 10 A = 0; B = 1; control = `ALU_OR;
        # 10 A = 0; B = 0; control = `ALU_NOR;
        # 10 A = 0; B = 1; control = `ALU_NOR;
        # 10 A = 1; B = 0; control = `ALU_NOR;
        # 10 A = 1; B = 1; control = `ALU_NOR;
        # 10 A = 1; B = 1; control = `ALU_XOR;

        //sub a number from itself; *need zero signal*
        # 10 A = -1; B = -1; control = `ALU_SUB;
        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
endmodule // alu32_test
