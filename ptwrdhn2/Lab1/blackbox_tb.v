module blackbox_test;

    reg c_in, t_in, y_in;                           // these are inputs to "circuit under test"
                                              // use "reg" not "wire" so can assign a value
    wire u_out;                        // wires for the outputs of "circuit under test"

    blackbox b1 (u_out, c_in, t_in, y_in);  // the circuit under test
    
    initial begin                             // initial = run at beginning of simulation
                                              // begin/end = associate block with initial
 
        $dumpfile("blackbox.vcd");                  // name of dump file to create
        $dumpvars(0, blackbox_test);                 // record all signals of module "sc_test" and sub-modules
                                              // remember to change "sc_test" to the correct
                                              // module name when writing your own test benches
        
        // test all four input combinations
        // remember that 2 inputs means 2^2 = 4 combinations
        // 3 inputs would mean 2^3 = 8 combinations to test, and so on
        // this is very similar to the input columns of a truth table
        c_in = 0; t_in = 0; y_in = 0; # 10;             // set initial values and wait 10 time units
        c_in = 0; t_in = 0; y_in = 1; # 10;             // change inputs and then wait 10 time units
        c_in = 0; t_in = 1; y_in = 0; # 10;             // as above
        c_in = 0; t_in = 1; y_in = 1; # 10;
        c_in = 1; t_in = 0; y_in = 0; # 10;             // set initial values and wait 10 time units
        c_in = 1; t_in = 0; y_in = 1; # 10;             // change inputs and then wait 10 time units
        c_in = 1; t_in = 1; y_in = 0; # 10;             // as above
        c_in = 1; t_in = 1; y_in = 1; # 10;
 
        $finish;                              // end the simulation
    end                      
    
    initial
        $monitor("At time %2t, c_in = %d t_in = %d y_in = %d u_out = %d",
                 $time, c_in, t_in, y_in, u_out);
endmodule // blackbox_test