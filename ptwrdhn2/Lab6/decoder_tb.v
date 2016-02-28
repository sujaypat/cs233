module decoder_test;
    reg [5:0] opcode, funct;
    reg       zero  = 0;

    initial begin
		$dumpfile("decoder.vcd");
		$dumpvars(0, decoder_test);

		// remember that all your instructions from last week should still work
		     opcode = `OP_OTHER0; funct = `OP0_ADD; // see if addition still works
		# 10 opcode = `OP_OTHER0; funct = `OP0_SUB; // see if subtraction still works
		// test all of the others here
		# 10 opcode = `OP_OTHER0; funct = `OP0_AND;
		# 10 opcode = `OP_OTHER0; funct = `OP0_OR;
		# 10 opcode = `OP_OTHER0; funct = `OP0_NOR;
		# 10 opcode = `OP_OTHER0; funct = `OP0_XOR;
		# 10 opcode = `OP_ADDI;
		# 10 opcode = `OP_ANDI;
		# 10 opcode = `OP_ORI;
		# 10 opcode = `OP_XORI;
		# 10 opcode = 6'b101010; funct = `OP0_ADD;
		# 10 opcode = 6'b110111; funct = `OP0_SUB;
		# 10 opcode = 6'b110111; funct = `OP0_AND;
		# 10 opcode = 6'b110111; funct = `OP0_OR;
		# 10 opcode = 6'b110111; funct = `OP0_NOR;
		# 10 opcode = 6'b110111; funct = `OP0_XOR;



        // as should all the new instructions from this week
        # 10 opcode = `OP_BEQ; zero = 0; // try a not taken beq
        # 10 opcode = `OP_BEQ; zero = 1; // try a taken beq
        // add more tests here!
		# 10 opcode = `OP_BNE; zero = 0;
		# 10 opcode = `OP_BNE; zero = 1;
		# 10 opcode = `OP_J;
		# 10 opcode = `OP_OTHER0; funct = `OP0_JR;
		# 10 opcode = `OP_LUI;
		# 10 opcode = `OP_LW;
		# 10 opcode = `OP_LBU;
		# 10 opcode = `OP_SW;
		# 10 opcode = `OP_SB;
		# 10 opcode = 6'h20; funct = 6'h20; zero = 0;
		# 10 opcode = 6'h22; funct = 6'h22; zero = 0;
		# 10 opcode = 6'h25; funct = 6'h25; zero = 0;
		# 10 opcode = 6'h27; funct = 6'h27; zero = 0;
		# 10 opcode = 6'h26; funct = 6'h26; zero = 0;



        # 10 $finish;
    end

    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire       writeenable, rd_src, alu_src2, except;
    wire [1:0] control_type;
    wire       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    mips_decode decoder(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                        mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                        opcode, funct, zero);
endmodule // decoder_test
