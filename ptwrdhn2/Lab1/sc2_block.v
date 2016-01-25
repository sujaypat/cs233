// Complete the sc2_block module in this file
// Don't put any code in this file besides the sc2_block

module sc2_block(s, cout, a, b, cin);
   output s, cout;
   input  a, b, cin;
   wire   s1, c1, c2;

   sc_block b1(s1, c1, a, b);
   sc_block b2(s, c2, s1, cin);
   or o1(cout, c1, c2);
   
endmodule // sc2_block
