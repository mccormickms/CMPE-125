`timescale 1ns / 1ps

module half_adder(input D,input E, output reg C_OUT, SUM);

always @ (*)
begin
    case ({D, E})
        2'b00 : begin SUM = 0; C_OUT = 0; end
        2'b01 : begin SUM = 1; C_OUT = 0; end // XOR function for D and E
        2'b10 : begin SUM = 1; C_OUT = 0; end
        2'b11 : begin SUM = 0; C_OUT = 1; end // Carry bit if both D and E are 1
    endcase
end 
endmodule
