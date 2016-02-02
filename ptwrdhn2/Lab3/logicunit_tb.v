module logicunit_test;
    // exhaustively test your logic unit by adapting mux4_tb.v

   reg x_in, y_in;
   reg [1:0] control = 0;

   always #1 x_in = !x_in;
   always #1 y_in = !y_in;


   initial begin
      $dumpfile("logicunit.vcd");
      $dumpvars(0, logicunit_test);


      # 16 control = 1;
      # 16 control = 2;
      # 16 control = 3;
      # 16 $finish;
   end
   
   wire out;
   logicunit l1(out, x_in, y_in, control);
   

endmodule // logicunit_test
