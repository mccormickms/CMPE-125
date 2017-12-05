`timescale 1ns / 1ps

module eight_bit_CLA(input [7:0] A_in, B_in,input C_in, output [7:0] Out, output C_out);

wire C_OUT_to_CIN;

assign C_in = 0;

    CLA_top LOW (.A_top(A_in[3:0]), .B_top(B_in[3:0]), .C_IN_top(C_in), .Out_top(Out[3:0]), .C_Out_top(C_OUT_to_CIN));
    CLA_top HIGH (.A_top(A_in[7:4]), .B_top(B_in[7:4]), .C_IN_top(C_OUT_to_CIN), .Out_top(Out[7:4]), .C_Out_top(C_out));

endmodule
