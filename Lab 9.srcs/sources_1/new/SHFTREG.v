`timescale 1ns / 1ps

module SHFTREG(clk, rst, SR, SL, LD, L_in, R_in, D, Q);

parameter DATA_WIDTH=4;
input clk, rst, SR, SL, LD, L_in, R_in;
input [DATA_WIDTH-1:0] D;
output reg [DATA_WIDTH-1:0] Q;

always@(posedge clk) begin
    if(rst) begin
        Q=0;
    end else if(LD) begin
        Q=D;
    end else if(SL) begin
        Q[DATA_WIDTH-1:1]=Q[DATA_WIDTH-2:0];
        Q[0]=R_in;
    end else if(SR) begin
        Q[DATA_WIDTH-2:0]=Q[DATA_WIDTH-1:1];
        Q[DATA_WIDTH-1]=L_in;
    end else begin
        Q[DATA_WIDTH-1:0]=Q[DATA_WIDTH-1:0];
    end
end
endmodule
