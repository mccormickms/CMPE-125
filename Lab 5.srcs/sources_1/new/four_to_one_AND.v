`timescale 1ns / 1ps

module four_to_one_AND(input [3:0] A, input B, output reg [3:0] AxB);

always @ (*)
begin
    AxB = ({A[3]&B, A[2]&B, A[1]&B, A[0]&B});
end
endmodule
