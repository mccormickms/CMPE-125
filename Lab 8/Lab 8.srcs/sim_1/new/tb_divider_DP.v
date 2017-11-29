`timescale 1ns / 1ps

module tb_divider_DP();

reg [3:0] x, y;                             //Data inputs X=dividend, Y=divisor
reg R_MUX_ctrl;
reg Rem_MUX_ctrl;                           //
reg X_MUX_ctrl;                             //MUX control signal for X register R_in
reg Q_MUX_ctrl;                             //MUX control signal for Quotient MUX 
reg R_SL, R_SR, R_LD;                       //Control signals for R register
reg X_SL, X_LD;                             //Control signals for X register
reg Y_LD;                                   //Control signal for Y register                                
//reg [3:0] cnt_n;                            //Input for counter
reg cnt_LD, cnt_CE;                         //Control signals for counter
reg clk, rst;                               //CLOCK and RESET signals

wire lt_flag, div_z;                        //Output less than flag
wire [3:0] R, Q, cnt_out;

reg [3:0] tb_quotient, tb_remainder;
reg tb_div_z;
integer counter_x, counter_y;

DP DUT(
    .x(x),
    .y(y),
    .R_MUX_ctrl(R_MUX_ctrl),
    .X_MUX_ctrl(X_MUX_ctrl),
    .Rem_MUX_ctrl(Rem_MUX_ctrl),
    .Q_MUX_ctrl(Q_MUX_ctrl),
    .R_SL(R_SL),
    .R_LD(R_LD),
    .R_SR(R_SR),
    .X_SL(X_SL),
    .X_LD(X_LD),
    .Y_LD(Y_LD),
    //.cnt_n(cnt_n),
    .cnt_LD(cnt_LD),
    .cnt_CE(cnt_CE),
    .clk(clk),
    .rst(rst),
    
    .lt_flag(lt_flag),
    .div_z(div_z),
    .cnt_out(cnt_out),
    .R(R),
    .Q(Q)
    );

task tick;
    begin
        clk=1'b0; #10;
        clk=1'b1; #10;
    end
endtask

initial begin
    rst=1'b1;
    tick;
    rst=1'b0;
    
    for(counter_x=0; counter_x<16; counter_x=counter_x+1) begin
        x=counter_x;
        for(counter_y=0; counter_y<16; counter_y=counter_y+1) begin
            tb_div_z=1'b0;
            y=counter_y; #5;
            if(y==0) begin
                tb_div_z=1'b1;
            end
            if(tb_div_z!=div_z) begin
                $display("Error, div_z flag not being set. Expected %d, actual %d", tb_div_z, div_z);
                $stop;
            end
            //s0
            Rem_MUX_ctrl=1'b0;
            Q_MUX_ctrl=1'b0;
            //s1
            //R[4:0] <--0
            R_MUX_ctrl=1'b0;
            R_LD=1'b1;
            //X<-dividend
            X_LD=1'b1;
            //Y<-divisor
            Y_LD=1'b1;
            //cnt<-4
           // cnt_n=4'b0100;
            cnt_LD=1'b1;
            cnt_CE=1'b1;
            
            tick;
            
            //s2
            R_LD=1'b0;
            X_LD=1'b0;
            Y_LD=1'b0;
            cnt_LD=1'b0;
            cnt_CE=1'b0;
            //R[4:0]<-{R[3:0],X[3]
            R_SL=1'b1;
            //X[3:0]<-{X[2:0],0}
            X_MUX_ctrl=1'b0;
            X_SL=1'b1;
            
            tick;
            
            //s3
            while(cnt_out!=4'b0000) begin
                R_SL=1'b0;
                X_SL=1'b0;
                //cnt<-cnt-1
                cnt_CE=1'b1;
                
                tick;
                
                if(lt_flag) begin
                    //s5
                    cnt_CE=1'b0;
                    R_SL=1'b1;
                    X_MUX_ctrl=1'b0;
                    X_SL=1'b1;
                end else begin
                    //s4
                    cnt_CE=1'b0;
                    R_MUX_ctrl=1'b1;
                    R_LD=1'b1; //unsure if this and next block of code require seperate states in CU
                    
                    tick;
                    
                    R_LD=1'b0;
                    R_MUX_ctrl=1'b0;
                    R_SL=1'b1;
                    X_MUX_ctrl=1'b1;
                    X_SL=1'b1;
                end
                
                tick;
                X_MUX_ctrl=1'b0;
                R_SL=1'b0;
                X_SL=1'b0;
            end
            //s6
            R_SR=1'b1;
            tick;
            R_SR=1'b0;
            //s7
            Rem_MUX_ctrl=1'b1;
            Q_MUX_ctrl=1'b1;
            
            tick;
            
            tb_quotient=x/y;
            tb_remainder=x%y;
            
            //Check
            if(tb_quotient!=Q) begin
                $display("Incorrect quotient, expected %d, actual %d", tb_quotient, Q);
            end
            if(tb_remainder!=R) begin
                $display("x: %d, y: %d", x, y);
                $display("Incorrect remainder, expected %d, actual %d", tb_remainder, R);
            end
        end
    end
    $display("ALL TESTS COMPLETED SUCCESSFULLY!");
end

endmodule
