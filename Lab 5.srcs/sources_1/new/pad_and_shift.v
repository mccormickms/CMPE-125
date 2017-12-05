`timescale 1ns / 1ps

module pad_and_shift(input [3:0] AxB, input shift, output reg [7:0] PPx);

always @ (*)
begin
    PPx = ({4'b0, AxB});
    PPx = PPx << shift;
end
endmodule
