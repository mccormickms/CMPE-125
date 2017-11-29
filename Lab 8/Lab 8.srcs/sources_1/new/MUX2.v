`timescale 1ns / 1ps

module MUX2(d0, d1, Sel, out);
parameter DATA_WIDTH=4;
input Sel;
input [DATA_WIDTH-1:0] d0;
input [DATA_WIDTH-1:0] d1;
output reg [DATA_WIDTH-1:0] out;

always@(d0, d1, Sel) begin
    if(Sel) begin
        out=d1;
    end else begin
        out=d0;
    end
end
endmodule
