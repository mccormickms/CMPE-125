`timescale 1ns / 1ps

module COMP(
    input [3:0] in_a, in_b,
    output lt
    );

assign lt = (in_a<in_b) ? 1 : 0;

endmodule
