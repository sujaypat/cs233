module alu1_test;
    // exhaustively test your 1-bit ALU by adapting mux4_tb.v

   reg a_in, b_in, cin_in;
   reg [2:0] control = 0;
   
   always #1 a_in = !a_in;
   always #1 b_in = !b_in;
   always #1 cin_in = !cin_in;
   
   initial begin
      $dumpfile("alu1.vcd");
      $dumpvars(0, alu1_test);

      # 16 control = 1;
      # 16 control = 2;
      # 16 control = 3;
      # 16 control = 4;
      # 16 control = 5;
      # 16 control = 6;
      # 16 control = 7;
      # 16 $finish;

   end // initial begin
   
   wire out, cout;
   alu1 a1(out, cout, a_in, b_in, cin_in, control);
   


endmodule
