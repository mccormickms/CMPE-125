//#4bit_mult_top.v
`timescale 1ns / 1ps

module mult_top(input[3:0] A_top, B_top, output [7:0] out_top, output C_out_top);

wire [3:0] PP0; // 0000(A&(B0))
wire [3:0] PP1; // 000(A&(B1))0
wire [3:0] PP2; // 00(A&(B2))00
wire [3:0] PP3; // 0(A&(B3))000
wire [7:0] Sum_1;
wire [7:0] Sum_2;

wire C_in_spare;
wire C_out_spare;

assign C_in_spare = 0;

//bit_multiplier B1(.A(A_top), .B(B_top), .AxB( {PP3, PP2, PP1, PP0} ));
four_to_one_AND F1(.A(A_top), .B(B_top[0]), .AxB(PP0));
four_to_one_AND F2(.A(A_top), .B(B_top[1]), .AxB(PP1));
four_to_one_AND F3(.A(A_top), .B(B_top[2]), .AxB(PP2));
four_to_one_AND F4(.A(A_top), .B(B_top[3]), .AxB(PP3));

eight_bit_CLA C1(.A_in({4'b0, PP0}), .B_in({3'b0, PP1, 1'b0}), .C_in(C_in_spare), .Out(Sum_1), .C_out(C_out_spare));
eight_bit_CLA C2(.A_in({2'b0, PP2, 2'b0}), .B_in({1'b0, PP3, 3'b0}), .C_in(C_in_spare), .Out(Sum_2), .C_out(C_out_spare));

eight_bit_CLA C3(.A_in(Sum_1), .B_in(Sum_2), .C_in(C_in_spare), .Out(out_top), .C_out(C_out_top));

endmodule