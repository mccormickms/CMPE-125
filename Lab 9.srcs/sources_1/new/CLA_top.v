`timescale 1ns / 1ps

module CLA_top(input C_IN_top, input [3:0] A_top, B_top,
               output [3:0] Out_top, output C_Out_top);
wire [7:0] HA_to_CLA; // outputs from half adders to CLA gen
wire [3:0] CLA_to_ADDER; // outputs from CLA gen to XOR for final SUM

//sums to even, carry to odd                                                                    
half_adder H1 (.D(A_top[0]), .E(B_top[0]), .SUM(HA_to_CLA[0]), .C_OUT(HA_to_CLA[1]));
half_adder H2 (.D(A_top[1]), .E(B_top[1]), .SUM(HA_to_CLA[2]), .C_OUT(HA_to_CLA[3]));
half_adder H3 (.D(A_top[2]), .E(B_top[2]), .SUM(HA_to_CLA[4]), .C_OUT(HA_to_CLA[5]));
half_adder H4 (.D(A_top[3]), .E(B_top[3]), .SUM(HA_to_CLA[6]), .C_OUT(HA_to_CLA[7]));

CLA_gen C1  (.C_IN(C_IN_top),
             // sum output of each half adder goes to sum input on CLA gen
             .P0(HA_to_CLA[0]), .P1(HA_to_CLA[2]), .P2(HA_to_CLA[4]), .P3(HA_to_CLA[6]),
             // carry output of each half adder goes to carry input on CLA gen
             .G0(HA_to_CLA[1]), .G1(HA_to_CLA[3]), .G2(HA_to_CLA[5]), .G3(HA_to_CLA[7]),
             // carry output of CLA gen goes to XOR for final sum
             .C0(CLA_to_ADDER[0]), .C1(CLA_to_ADDER[1]), .C2(CLA_to_ADDER[2]), .C3(CLA_to_ADDER[3]),
             // final carry out signal is MSB
             .C4(C_Out_top));

             // sum output from half adder is P_IN and carry out from CLA_gen is C_IN
             // final output is XOR of carry in and sum
CLA_adder A1 (.P_IN(HA_to_CLA[0]), .C_IN(CLA_to_ADDER[0]), .SUM(Out_top[0]));
CLA_adder A2 (.P_IN(HA_to_CLA[2]), .C_IN(CLA_to_ADDER[1]), .SUM(Out_top[1]));
CLA_adder A3 (.P_IN(HA_to_CLA[4]), .C_IN(CLA_to_ADDER[2]), .SUM(Out_top[2]));
CLA_adder A4 (.P_IN(HA_to_CLA[6]), .C_IN(CLA_to_ADDER[3]), .SUM(Out_top[3]));

endmodule
