`timescale 1ns / 1ps

module COMP_Z(
    input [3:0] in_a, in_b,
    output lt
    );

assign lt = (in_a == 0) ? 1 : 0;

endmodule
