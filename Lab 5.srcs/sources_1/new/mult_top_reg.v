`timescale 1ns / 1ps

module mult_top_reg(input[3:0] A_top, B_top, input clk, rst, output [7:0] out_top, state_reg1, state_reg2, output C_out_top);

wire [3:0] PP0; // 0000(A&(B0))
wire [3:0] PP1; // 000(A&(B1))0
wire [3:0] PP2; // 00(A&(B2))00
wire [3:0] PP3; // 0(A&(B3))000
wire [7:0] Sum_1; // output of C1
wire [7:0] Sum_2; // output of C2
wire [3:0] Dreg1; // output of input reg for A
wire [3:0] Dreg2; // output of input reg for B
wire [7:0] Sreg1; // output of state reg for PP0 and PP1
wire [7:0] Sreg2; // output of state reg for PP2 and PP3
wire [7:0] Preg;  // output of final reg

wire C_out_spare;

D_param_reg #(4) D1 (clk, rst, 1, A_top, Dreg1);
D_param_reg #(4) D2 (clk, rst, 1, B_top, Dreg2);

four_to_one_AND F1(.A(Dreg1), .B(Dreg2[0]), .AxB(PP0));
four_to_one_AND F2(.A(Dreg1), .B(Dreg2[1]), .AxB(PP1));
four_to_one_AND F3(.A(Dreg1), .B(Dreg2[2]), .AxB(PP2));
four_to_one_AND F4(.A(Dreg1), .B(Dreg2[3]), .AxB(PP3));

eight_bit_CLA C1(.A_in({4'b0, PP0}), .B_in({3'b0, PP1, 1'b0}), .C_in(1'b0), .Out(Sum_1), .C_out(C_out_spare));
eight_bit_CLA C2(.A_in({2'b0, PP2, 2'b0}), .B_in({1'b0, PP3, 3'b0}), .C_in(1'b0), .Out(Sum_2), .C_out(C_out_spare));

D_param_reg D3 (clk, rst, 1, Sum_1, Sreg1);
D_param_reg D4 (clk, rst, 1, Sum_2, Sreg2);

assign state_reg1 = Sreg1;
assign state_reg2 = Sreg2;

eight_bit_CLA C3(.A_in(Sreg1), .B_in(Sreg2), .C_in(0), .Out(Preg), .C_out(C_out_top));

D_param_reg D5 (clk, rst, 1, Preg, out_top);

endmodule
