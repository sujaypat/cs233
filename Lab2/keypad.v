module keypad(valid, number, a, b, c, d, e, f, g);
   output valid;
   output [3:0] number;
   input a, b, c, d, e, f, g;
   
   
   assign valid = ((d && (a || b || c)) || (e && (a || b || c)) || (f && (a || b || c)) || g);
   assign number[3] = (f && (b || c));
   assign number[2] = ((e && (a || b || c)) || (a && f));
   assign number[1] = ((d && (b || c)) || (c && e) || (a && f));
   assign number[0] = ((d && (a || c)) || (b && e) || (f && (a || c)));
   
   
endmodule // keypad
