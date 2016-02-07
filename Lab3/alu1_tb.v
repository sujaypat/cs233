module alu1_test;
    // exhaustively test your 1-bit ALU by adapting mux4_tb.v

   reg a_in = 0;
   reg b_in = 0;
   reg cin_in = 0;
   reg [2:0] control = 0;
   
   always #1 a_in = !a_in;
   always #2 b_in = !b_in;
   always #4 cin_in = !cin_in;
   
   initial begin
      $dumpfile("alu1.vcd");
      $dumpvars(0, alu1_test);

      # 8 control = 1;
      # 8 control = `ALU_ADD;
      # 8 control = `ALU_SUB;
      # 8 control = `ALU_AND;
      # 8 control = `ALU_OR;
      # 8 control = `ALU_NOR;
      # 8 control = `ALU_XOR;
      # 8 $finish;

   end // initial begin
   
   wire out, cout;
   alu1 a1(out, cout, a_in, b_in, cin_in, control);
   


endmodule
