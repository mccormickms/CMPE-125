`timescale 1ns / 1ps

module place_check(input [7:0] total, output reg [3:0] ones, tens, hundreds);

integer holder;

always @ (*)
    begin
        if ((total > 199) && (total < 300))
        begin
            hundreds = 2; holder = total - 200;
        end
        else if ((total > 99) && (total < 200))
        begin
            hundreds = 1; holder = total - 100;
        end
        else if (total < 100)
        begin
            hundreds = 0; holder = total;
        end

        if ((holder > 9) && (holder < 20))
        begin
            tens = 1; ones = holder - 10;
        end
        else if ((holder > 19) && (holder < 29)) 
        begin
            tens = 2; ones = holder - 20;
        end
        else if ((holder > 29) && (holder < 39)) 
        begin
            tens = 3; ones = holder - 30;
        end
        else if ((holder > 39) && (holder < 49)) 
        begin
            tens = 4; ones = holder - 40;
        end
        else if ((holder > 49) && (holder < 59)) 
        begin
            tens = 5; ones = holder - 50;
        end
        else if ((holder > 59) && (holder < 69)) 
        begin
            tens = 6; ones = holder - 60;
        end
        else if ((holder > 69) && (holder < 79)) 
        begin
            tens = 7; ones = holder - 70;
        end
        else if ((holder > 79) && (holder < 89)) 
        begin
            tens = 8; ones = holder - 80;
        end
        else if ((holder > 89) && (holder < 99)) 
        begin
            tens = 9; ones = holder - 90;
        end
        else
        begin
            tens = 0; ones = holder;
        end
    end
endmodule
