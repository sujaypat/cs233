module alu32(out, overflow, zero, negative, A, B, control);
    output [31:0] out;
    output        overflow, zero, negative;
    input  [31:0] A, B;
    input   [2:0] control;
    wire   [31:0] carryin;
   

    //00 = AND, 01 = OR, 10 = NOR, 11 = XOR
   alu1 a1(out[0], carryin[0], A[0], B[0], control[0], control);
   alu1 a2(out[1], carryin[1], A[1], B[1], carryin[0], control);
   alu1 a3(out[2], carryin[2], A[2], B[2], carryin[1], control);
   alu1 a4(out[3], carryin[3], A[3], B[3], carryin[2], control);
   alu1 a5(out[4], carryin[4], A[4], B[4], carryin[3], control);
   alu1 a6(out[5], carryin[5], A[5], B[5], carryin[4], control);
   alu1 a7(out[6], carryin[6], A[6], B[6], carryin[5], control);
   alu1 a8(out[7], carryin[7], A[7], B[7], carryin[6], control);
   alu1 a9(out[8], carryin[8], A[8], B[8], carryin[7], control);
   alu1 a10(out[9], carryin[9], A[9], B[9], carryin[8], control);
   alu1 a11(out[10], carryin[10], A[10], B[10], carryin[9], control);
   alu1 a12(out[11], carryin[11], A[11], B[11], carryin[10], control);
   alu1 a13(out[12], carryin[12], A[12], B[12], carryin[11], control);
   alu1 a14(out[13], carryin[13], A[13], B[13], carryin[12], control);
   alu1 a15(out[14], carryin[14], A[14], B[14], carryin[13], control);
   alu1 a16(out[15], carryin[15], A[15], B[15], carryin[14], control);
   alu1 a17(out[16], carryin[16], A[16], B[16], carryin[15], control);
   alu1 a18(out[17], carryin[17], A[17], B[17], carryin[16], control);
   alu1 a19(out[18], carryin[18], A[18], B[18], carryin[17], control);
   alu1 a20(out[19], carryin[19], A[19], B[19], carryin[18], control);
   alu1 a21(out[20], carryin[20], A[20], B[20], carryin[19], control);
   alu1 a22(out[21], carryin[21], A[21], B[21], carryin[20], control);
   alu1 a23(out[22], carryin[22], A[22], B[22], carryin[21], control);
   alu1 a24(out[23], carryin[23], A[23], B[23], carryin[22], control);
   alu1 a25(out[24], carryin[24], A[24], B[24], carryin[23], control);
   alu1 a26(out[25], carryin[25], A[25], B[25], carryin[24], control);
   alu1 a27(out[26], carryin[26], A[26], B[26], carryin[25], control);
   alu1 a28(out[27], carryin[27], A[27], B[27], carryin[26], control);
   alu1 a29(out[28], carryin[28], A[28], B[28], carryin[27], control);
   alu1 a30(out[29], carryin[29], A[29], B[29], carryin[28], control);
   alu1 a31(out[30], carryin[30], A[30], B[30], carryin[29], control);
   alu1 a32(out[31], carryin[31], A[31], B[31], carryin[30], control);
   

   assign negative = out[31];
   zero_checker z1(zero, out);
   xor x1(overflow, carryin[31], carryin[30]);
   

endmodule // alu32
