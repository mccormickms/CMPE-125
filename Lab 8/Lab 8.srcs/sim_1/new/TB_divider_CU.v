`timescale 1ns / 1ps

module TB_divider_CU();
reg tb_Go, tb_clk, tb_rst, tb_RltY, tb_divZ;
reg [3:0] tb_cntout;

wire [12:0] tb_ctrl;
wire [3:0] tb_State;
reg [3:0] tb_Next;
wire tb_Done, tb_Err;

task tick; 
	begin
		#5 tb_clk = 1;  
		#5 tb_clk = 0; 
	end 
endtask

task check_state;
	begin
		case(tb_State)
			0: begin expected = tb_S0; tb_Next = 4'b0001; end
			1: begin expected = tb_S1; tb_Next = 4'b0010; end
			2: begin 
				expected = tb_S2; 
				if(tb_divZ)
				    begin 
				    	tb_Next = 4'b1000; 
				    end
				    else 
				    begin
				    	tb_Next = 4'b0011;
				    end
			   end
			3: begin 
				expected = tb_S3;
					if(loop_once == 0)
						begin 
							//$display ("S3 loop = 0");
							loop_once = 1; #5; 
						end
					else
					begin
						//$display ("S3 loop = 1");
						tb_cntout = 4'b0001; // set count out to 1 to avoid infinite loop
				    end
				    if(tb_RltY)
				    begin 
				    	tb_Next = 4'b0101; 
				    end
				    else 
				    begin
				    	tb_Next = 4'b1001;
				    end
			   end
			4: begin 
				expected = tb_S4;
					if(tb_cntout)
				    begin 
				    	tb_Next = 4'b0110; 
				    end
			    	else 
				    begin
				    	tb_Next = 4'b0011;
				    end
			   end
			5: begin 
				expected = tb_S5; 
				if(tb_cntout)
				    begin 
				    	tb_Next = 4'b0110; 
				    end
			    	else 
				    begin
				    	tb_Next = 4'b0011;
				    end
			   end
			6: begin expected = tb_S6; tb_Next = 4'b0111; end
			7: begin expected = tb_S7; tb_Next = 4'b0000; end
			8: begin expected = tb_SE; tb_Next = 4'b0000; end
			9: begin expected = tb_S9; tb_Next = 4'b0100; end
		endcase
	end
endtask

divider_CU DUT1 (.Go(tb_Go), .clk(tb_clk), .reset(tb_rst), .R_lt_Y(tb_RltY), .cnt_out(tb_cntout), .divZ(tb_divZ),
                 .Done(tb_Done), .Error(tb_Err), .State(tb_State), .ctrl_sig(tb_ctrl));

integer i, j, loop_once;
				   //RMX1 RMX2 QMX XMX R_LD X_LD Y_LD R_SL X_SL R_SR CNT_LD CNT_CE RST_DP DONE ERR STATE
reg [18:0] tb_S0 = 19'b_0____0___0___0____0____0____0____0____0____0______0______0______0____0___0__0000;
reg [18:0] tb_S1 = 19'b_0____0___0___0____1____1____1____0____0____0______1______1______0____0___0__0001;
reg [18:0] tb_S2 = 19'b_0____0___0___0____0____0____0____1____1____0______0______0______0____0___0__0010;
reg [18:0] tb_S3 = 19'b_0____0___0___0____0____0____0____0____0____0______0______1______0____0___0__0011;
reg [18:0] tb_S4 = 19'b_0____0___0___1____0____0____0____1____1____0______0______0______0____0___0__0100;
reg [18:0] tb_S5 = 19'b_0____0___0___0____0____0____0____1____1____0______0______0______0____0___0__0101;
reg [18:0] tb_S6 = 19'b_0____0___0___0____0____0____0____0____0____1______0______0______0____0___0__0110;
reg [18:0] tb_S7 = 19'b_0____1___1___0____0____0____0____0____0____0______0______0______0____1___0__0111;
reg [18:0] tb_SE = 19'b_0____0___0___0____0____0____0____0____0____0______0______0______1____0___1__1000;
reg [18:0] tb_S9 = 19'b_1____0___0___0____1____0____0____0____0____0______0______0______0____0___0__1001;

reg [18:0] test;
reg [18:0] expected;

initial
begin
	tb_cntout = 4'b0000;
	tb_divZ = 0;
	tb_RltY = 0;
	tb_Next = 1;
	loop_once = 0;
	tick;
	tb_rst = 0;
	tick;
	tb_Go = 0;
	tb_rst = 1; //init to 0
	tick;
	tb_rst = 0;
	tick;
	tick;
	tb_Go = 1;
	
	for(i = 0; i <= 3; i = i + 1)
	begin
		{tb_divZ, tb_RltY} = i; #5; // None, R_lt_Y, divZ, both

		if(i == 0)
		begin
			for(j = 0; j <= 8; j = j + 1)
			begin
				
				tick; 
				test = {tb_ctrl, tb_Done, tb_Err, tb_State};
				if(tb_Next != tb_State)
				begin
					$display ("Error at next state prediction %1d", tb_State);
					$stop;
				end
				#5; 
				check_state; #5;
				
				if(test != expected)
				begin
					$display ("Error at state %1d", tb_State);
					$stop;
				end
			end
		loop_once = 0;
		tb_cntout = 4'b0000;
		end

		else if(i == 1)
		begin
			for(j = 0; j <= 8; j = j + 1)
			begin 
				tick; 
				test = {tb_ctrl, tb_Done, tb_Err, tb_State};
				if(tb_Next != tb_State)
				begin
					$display ("Error at  next state prediction %1d", tb_State);
					$stop;
				end
				#5; 
				check_state; #5;
				
				if(test != expected)
				begin
					$display ("Error at state %1d", tb_State);
					$stop;
				end
			end
		loop_once = 0;
		tb_cntout = 4'b0000;
		end

		else if(i == 2) // this is the divZ loop
		begin
			for(j = 0; j <= 3; j = j + 1)
			begin 
				tick; 
				test = {tb_ctrl, tb_Done, tb_Err, tb_State};
				if(tb_Next != tb_State)
				begin
					$display ("Error at  next state prediction %1d", tb_State);
					$stop;
				end
				#5; 
				check_state; #5;
				
				if(test != expected)
				begin
					$display ("Error at state %1d", tb_State);
					$stop;
				end
			end
		loop_once = 0;
		tb_cntout = 4'b0000;
		end

		else if(i == 3) // final loop, should be identical to previous loop
		begin
			for(j = 0; j <= 3; j = j + 1)
			begin 
				tick; 
				test = {tb_ctrl, tb_Done, tb_Err, tb_State};
				if(tb_Next != tb_State)
				begin
					$display ("Error at  next state prediction %1d", tb_State);
					$stop;
				end
				#5; 
				check_state; #5;
				
				if(test != expected)
				begin
					$display ("Error at state %1d", tb_State);
					$stop;
				end
			end
		tick;
		loop_once = 0;
		tb_cntout = 4'b0000;
		end
	end
	$display ("Success");
end

endmodule