`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2017 10:23:03 PM
// Design Name: 
// Module Name: divider_DP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module divider_DP(

    );
endmodule
`timescale 1ns / 1ps

module DP(
        input [3:0] x, y,
        input R_MUX_ctrl,
        input Rem_MUX_ctrl,
        input X_MUX_ctrl,
        input Q_MUX_ctrl,
        input R_SL, R_SR, R_LD,
        input X_SL, X_LD,
        input Y_LD,
       // input [3:0] cnt_n,
        input cnt_CE, cnt_LD,
        input clk, rst,
        
        output lt_flag, div_z,
        output [3:0] Q, R, cnt_out
        );

wire X_R_in;
wire [4:0] R_in, R_out;
wire [3:0] X_out, Y_out, sub_out;

//MUX controlling input to R(remainder) register
MUX2 #(.DATA_WIDTH(5)) M0(
                        .d0(5'b0),
                        .d1({R_out[4], sub_out}),
                        .out(R_in),
                        .Sel(R_MUX_ctrl)
                        );
                        
//R(remainder) Shift Register
SHFTREG #(.DATA_WIDTH(5)) S0(
                            .clk(clk),
                            .rst(rst),
                            .SR(R_SR),
                            .SL(R_SL),
                            .LD(R_LD),
                            .D(R_in),
                            .Q(R_out),
                            .R_in(X_out[3]),
                            .L_in(1'b0)
                            );
                            
//X MUX for determining R_in to be a 0 or a 1
MUX2 #(.DATA_WIDTH(1)) M1(
                            .d0(1'b0),
                            .d1(1'b1),
                            .out(X_R_in),
                            .Sel(X_MUX_ctrl)
                            );

//X(dividend) Shift Register
SHFTREG #(.DATA_WIDTH(4)) S1(
                            .clk(clk),
                            .rst(rst),
                            .SR(1'b0),  
                            .SL(X_SL),
                            .LD(X_LD),
                            .D(x),
                            .Q(X_out),
                            .R_in(X_R_in),
                            .L_in(1'b0)
                            );
                            
//Y(divisor) Register
SHFTREG #(.DATA_WIDTH(4)) S2(
                            .clk(clk),
                            .rst(rst),
                            .SR(1'b0),  
                            .SL(1'b0),
                            .LD(Y_LD),
                            .D(y),
                            .Q(Y_out),
                            .R_in(1'b0),
                            .L_in(1'b0)
                            );
                            
//Comparator for less than flag
COMP C1(
        .in_a(R_out[3:0]),
        .in_b(Y_out),
        .lt(lt_flag)
        );
        
//Comp for div_z
COMP_Z C2(
        .in_a(y),
        .in_b(5'b00001),
        .lt(div_z)
        );
        
//Subtractor
SUBTR S3(
        .in_a(R_out[3:0]),
        .in_b(Y_out),
        .c(sub_out)
        );
        
//Remainder MUX
MUX2 #(.DATA_WIDTH(4)) M2(
                        .d0(4'b0),
                        .d1(R_out[3:0]),    //changed from r_out[3:0]
                        .out(R),
                        .Sel(Rem_MUX_ctrl)
                        );
                        
//Quotient MUX
MUX2 #(.DATA_WIDTH(4)) M3(
                        .d0(4'b0),
                        .d1(X_out),
                        .out(Q),
                        .Sel(Q_MUX_ctrl)
                        );
                        
//Up/Down Counter
UD_CNT_4 U1(
            .D(3'b100),
            .LD(cnt_LD),
            .UD(1'b0),
            .CE(cnt_CE),
            .rst(~rst),
            .clk(clk),
            .Q(cnt_out)
            );
    
endmodule
