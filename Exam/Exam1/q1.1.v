// Design a circuit that compares two two-bit unsigned
// inputs (first and second) using the following rules:

// - If the two inputs are equal, then the output is 00
// - If the first input is greater, then the output is 01
// - If the second input is greater, then the output is 10

module comparator(out, first, second);
   output [1:0] out;
   input  [1:0] first, second;

   assign out[1] = (!first[1] & !first[0] & !second[1] & second[0])
 + (!first[1] & !first[0] & second[1] & !second[0])
 + (!first[1] & !first[0] & second[1] & second[0])
 + (!first[1] & first[0] & second[1] & !second[0])
 + (!first[1] & first[0] & second[1] & second[0])
 + (first[1] & !first[0] & second[1] & second[0]);
   assign out[0] = (!first[1] & first[0] & !second[1] & !second[0])
 + (first[1] & !first[0] & !second[1] & !second[0])
 + (first[1] & !first[0] & !second[1] & second[0])
 + (first[1] & first[0] & !second[1] & !second[0])
 + (first[1] & first[0] & !second[1] & second[0])
 + (first[1] & first[0] & second[1] & !second[0]);
   
   
endmodule // comparator

