`timescale 1ns / 1ps

module bit_multiplier(input [3:0] A, B, output reg [15:0] AxB);

always @ (*)
begin
	AxB[3:0]    = ({A[3]&B[0], A[2]&B[0], A[1]&B[0], A[0]&B[0]}); //PP0
	AxB[7:4]    = ({A[3]&B[1], A[2]&B[1], A[1]&B[1], A[0]&B[1]}); //PP1
	AxB[11:8]   = ({A[3]&B[2], A[2]&B[2], A[1]&B[2], A[0]&B[2]}); //PP2
	AxB[15:12]  = ({A[3]&B[3], A[2]&B[3], A[1]&B[3], A[0]&B[3]}); //PP3
end

endmodule
