`timescale 1ns / 1ps

module divider_DP_CU(Go, X_in, Y_in, clk, rst, Done, Error, Quotient, Remainder, CS);
	input Go, clk, rst;
	input [3:0] X_in, Y_in;
	output Done, Error;
	output [3:0] Quotient;
	output [3:0] Remainder;
	output [3:0] CS;

	wire [12:0] CU_ctrl;
	wire [3:0] cnt_out;
	wire less_than, divZ;

	DP U1(	.x(X_in),
			.y(Y_in),
			.clk(clk),
			.R_MUX_ctrl(CU_ctrl[12]),
			.Rem_MUX_ctrl(CU_ctrl[11]),
			.Q_MUX_ctrl(CU_ctrl[10]),
			.X_MUX_ctrl(CU_ctrl[9]),
			.R_LD(CU_ctrl[8]),
			.X_LD(CU_ctrl[7]),
			.Y_LD(CU_ctrl[6]),
			.R_SL(CU_ctrl[5]),
			.X_SL(CU_ctrl[4]),
			.R_SR(CU_ctrl[3]),
			.cnt_LD(CU_ctrl[2]),
			.cnt_CE(CU_ctrl[1]),
			.rst(CU_ctrl[0]),
			.lt_flag(less_than),
			.div_z(divZ),
			.cnt_out(cnt_out),
			.R(Remainder),
			.Q(Quotient)
			);

	divider_CU U0(	.Go(Go),
					.clk(clk),
					.reset(rst),
					.R_lt_Y(less_than),
					.cnt_out(cnt_out),
					.divZ(divZ),
					.Done(Done),
					.Error(Error),
					.ctrl_sig(CU_ctrl),
					.State(CS)
					);

endmodule