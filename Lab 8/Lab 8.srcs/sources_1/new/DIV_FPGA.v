`timescale 1ns / 1ps

module DIV_FPGA(input [3:0] in_x, in_y,
				  input Go_top, CLK100MHZ, rst, debounce,
				  output [7:0] LEDOUT, LEDSEL,
	              output [3:0] in_1_led, in_2_led,
	              output err_top_led,
				  output done_top_led);

supply1 [7:0] vcc;
wire DONT_USE, clk_5KHz, man_clk;
wire [3:0] State, Quotient, Remainder, Q_ones, Q_tens, R_ones, R_tens;
wire [7:0] State_LED, Q_ONES_LED, Q_TENS_LED, R_ONES_LED, R_TENS_LED;

assign in_1_led = in_x;
assign in_2_led = in_y;


	clk_gen CLK(.clk100MHz(CLK100MHZ), .rst(rst), .clk_4sec(DONT_USE), .clk_5KHz(clk_5KHz));

	button_debouncer BD1(.clk(clk_5KHz), .button(debounce), .debounced_button(man_clk));

	divider_DP_CU D1(.Go(Go_top), .clk(man_clk), .rst(rst), .X_in(in_x), .Y_in(in_y), .CS(State),  
					 .Done(done_top_led), .Error(err_top_led), .Quotient(Quotient), .Remainder(Remainder));

	place_check P1(.total(Quotient), .ones(Q_ones), .tens(Q_tens));
	place_check P2(.total(Remainder), .ones(R_ones), .tens(R_tens));

	bcd_to_7seg BCD1(.BCD(State), .s(State_LED));
	bcd_to_7seg BCD2(.BCD(Q_ones), .s(Q_ONES_LED));
	bcd_to_7seg BCD3(.BCD(Q_tens), .s(Q_TENS_LED));
	bcd_to_7seg BCD4(.BCD(R_ones), .s(R_ONES_LED));
	bcd_to_7seg BCD5(.BCD(R_tens), .s(R_TENS_LED));

	led_mux L1(.clk(clk_5KHz), .rst(rst), 
	           .LED0(Q_ONES_LED), .LED1(Q_TENS_LED), .LED2(vcc), .LED3(State_LED), 
	           .LED4(vcc), .LED5(vcc), .LED6(R_ONES_LED), .LED7(R_TENS_LED), 
	           .LEDSEL(LEDSEL), .LEDOUT(LEDOUT));

endmodule