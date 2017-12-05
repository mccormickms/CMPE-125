`timescale 1ns / 1ps

module Calc_DP_CU(go, op, in1, in2, clk, cs, done, out);
    input go, clk;
    input [1:0] op;
    input [2:0] in1, in2;
    output [3:0] cs;
    output done;
    output [2:0] out;
    
    wire [13:0] CU_ctrl;
    
    Calc_DP U1(.in1(in1),
	           .in2(in2),
	           .s1(CU_ctrl[13:12]),
	           .wa(CU_ctrl[11:10]),
	           .we(CU_ctrl[9]),
	           .raa(CU_ctrl[8:7]),
	           .rea(CU_ctrl[6]),
	           .rab(CU_ctrl[5:4]),
	           .reb(CU_ctrl[3]),
	           .c(CU_ctrl[2:1]),
	           .s2(CU_ctrl[0]),
	           .clk(clk),
	           .out(out)
           	);
    
    Calc_CU U0(.Go(go),
	           .Op(op),
	           .clk(clk),
	           .ctrl_sig(CU_ctrl),
	           .State(cs),
	           .Done(done)
            	);    
endmodule