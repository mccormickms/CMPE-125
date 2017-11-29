`timescale 1ns / 1ps

module tb_divider_DP_CU();
	reg tb_go, tb_clk, reset;
	reg [3:0] InX, InY;
	wire done, error;
	wire [3:0] Quotient, Remainder, State;


divider_DP_CU DUT(	.Go(tb_go),
					.clk(tb_clk),
					.rst(reset),
					.X_in(InX),
					.Y_in(InY),
					.Done(done),
					.Error(error),
					.Quotient(Quotient),
					.Remainder(Remainder),
					.CS(State));

integer data1 = 0;
integer data2 = 0;
integer go_status = 0;
reg [3:0] tb_Q, tb_R;

task tick; 
	begin
		#5 tb_clk = 1;  
		#5 tb_clk = 0; 
	end 
endtask

initial
begin
	// for loop for X value (dividend)
	for(data1 = 0; data1 <= 15; data1 = data1 + 1)
	begin
		InX = data1;

		//for loop for Y value (divisor
		for(data2 = 0; data2 <= 15; data2 = data2 + 1)
		begin
			InY = data2;

			//for loop for go status
			for(go_status = 0; go_status < 2; go_status = go_status + 1)
			begin
				tb_go = go_status;
				tick;

				//check for proper go function
				if((tb_go == 1'b0) && (State != 4'b0000))
				begin
					$display("ERROR, Go is %d and CS is %d, CS should be 0", tb_go, State);
					$stop;
				end

				else if(go_status>1'b0) 
                begin
                    if(tb_go != 1'b1) begin
                        $display("ERROR, Go is %d and should be 1", tb_go);
                        $stop;
                    end
        
                    while(!(done || error))
                    begin
                    	tick;
                    end

                    //Once state 8 has been reached check to make sure Done flag is thrown
                    if((State == 4'b0111) && (done != 1'b1)) 
                    begin
                        $display("ERROR, current state is %d and Done is %d", State, done);
                        $stop;
                    end

                    if((State == 4'b1000) && (error != 1'b1)) 
                    begin
                        $display("ERROR, current state is %d and Error is %d", State, error);
                        $stop;
                    end

                    if((State == 4'b1000) && (data2 != 1'b0)) 
                    begin
                        $display("ERROR, Error flag is high and divisor is %2d", data2);
                        $stop;
                    end

                    tb_Q = data1/data2;
                    tb_R = data1%data2;
                    #5;

                    //Here we check expected output with actual output
                    if(tb_Q != Quotient) 
                    begin
                        $display("ERROR, expected quotient: %d, actual quotient: %d", tb_Q, Quotient);
                        $stop;
                    end

                    if(tb_R != Remainder) 
                    begin
                        $display("ERROR, expected remainder: %d, actual remainder: %d", tb_R, Remainder);
                        $stop;
                    end
                    tick;
                end

			end
		end
	end
	$display("ALL TESTS COMPLETED SUCCESSFULLY!");
end

endmodule