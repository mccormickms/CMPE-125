`timescale 1ns / 1ps

module tb_mult_top_reg();
reg [3:0] tb_A;
reg [3:0] tb_B;
wire [7:0] tb_state_reg1;
wire [7:0] tb_state_reg2;
wire [7:0] tb_out_top;
wire tb_C_out_top;
integer A;
integer B;
integer C;
reg tb_clk;
reg [7:0] check;
reg [7:0] check_1;
reg [7:0] check_2;
reg [7:0] check_3;
reg [4:0] counter;
reg [3:0] post;

mult_top_reg DUT (.A_top(tb_A), .B_top(tb_B), .clk(tb_clk), .out_top(tb_out_top),
                  .state_reg1(tb_state_reg1), .state_reg2(tb_state_reg2), .C_out_top(tb_C_out_top));

initial
begin
counter = 0;
    for(A = 0; A < 16; A = A + 1)
    begin 
        for(B = 0; B < 16; B = B + 1)
        begin
            tb_A = A;
            tb_B = B;
            check = A * B;
            #5;
            check_3 = check_2;
            #5;
            check_2 = check_1;
            #5;
            check_1 = check;
            #5;
            tb_clk = 1; #5; tb_clk = 0; counter = counter + 1;
            #5;
            if ((counter > 1) && (tb_out_top != check_3))
            begin
                $display ("ERROR - multiplier output = %3d, inferred output = %3d", tb_out_top, check_3);
                $stop;
            end
        end
    end
    for (post = 0; post < 6; post = post + 1)
    begin
        check_3 = check_2;
        #5;
        check_2 = check_1;
        #5;
        check_1 = check;
        #5;
        tb_clk = 1; #5; tb_clk = 0; counter = counter + 1;
        #5;
        if ((counter > 1) && (tb_out_top != check_3))
        begin
            $display ("ERROR - multiplier output = %3d, inferred output = %3d", tb_out_top, check_3);
            $stop;
        end
    end
    $display ("Success");
end

endmodule