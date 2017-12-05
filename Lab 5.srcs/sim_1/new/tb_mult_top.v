`timescale 1ns / 1ps

module tb_mult_top();
reg [3:0] tb_A;
reg [3:0] tb_B;
wire [7:0] tb_out_top;
wire tb_C_out_top;
integer A;
integer B;
reg [7:0] check;

mult_top DUT (.A_top(tb_A), .B_top(tb_B), .out_top(tb_out_top), .C_out_top(tb_C_out_top));

initial
begin
    for(A = 0; A < 16; A = A + 1)
    begin 
        for(B = 0; B < 16; B = B + 1)
        begin
            tb_A = A;
            tb_B = B;
            check = A * B;
            #5;
            if (tb_out_top != check)
            begin
                $display ("ERROR - multiplier output = %8b, inferred output = %8b", tb_out_top, check);
                $stop;
            end
        end
    end
    $display ("Success");
end

endmodule
