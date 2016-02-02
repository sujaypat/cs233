## a code generator for the ALU chain in the 32-bit ALU
## see example_generator.py for inspiration
## 
## python generator.py
for i in range(2, 32):
    print("     alu1 a{0}(out[{1}], carryin[{1}], A[{1}], B[{1}], carryin[{2}], control);".format(i, i-1, i-2))
