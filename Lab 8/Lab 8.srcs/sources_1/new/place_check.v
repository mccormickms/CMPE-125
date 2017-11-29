`timescale 1ns / 1ps

module place_check(input [7:0] total, output reg [3:0] ones, tens);

integer holder;

always @ (*)
    begin
     
        if ((total > 9) && (total < 20))
        begin
            tens = 1; ones = total - 10;
        end
     
        else
        begin
            tens = 0; ones = total;
        end
    end
endmodule
