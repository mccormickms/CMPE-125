`timescale 1ns / 1ps

module UD_CNT_4(
                input [3:0] D,
                input LD, UD, CE, rst, clk,
                output reg [3:0] Q
                );

always @(posedge clk, negedge rst) begin
    if(!rst) 
    begin
        Q=4'b0000;
    end 

    else if(CE) 
    begin
        if(LD) 
        begin
            Q = D;
        end 

        else if(UD) 
        begin
            Q = Q + 4'b0001;
        end 

        else 
        begin
            Q = Q - 4'b0001;
        end
    end 

    else 
    begin
        Q = Q;
    end
end
endmodule
