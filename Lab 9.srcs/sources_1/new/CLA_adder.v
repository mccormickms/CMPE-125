`timescale 1ns / 1ps

module CLA_adder(input P_IN, C_IN, output reg SUM);

always @ (*)
begin
    SUM = P_IN ^ C_IN; // XOR function for outputs of CLA generator
end
endmodule
