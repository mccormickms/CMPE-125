`timescale 1ns / 1ps

module mult_FPGA(input [3:0] Ain, Bin,
                 input Cin, clk100MHz, rst, debounce,
                 output [7:0] LEDOUT, LEDSEL,
                 output [3:0] A_in_led, B_in_led);

supply1 [7:0] vcc;
wire [4:0] ones, tens, hundreds; // output of place_check, input to bcd_to_7seg
wire [7:0] Total, ONES, TENS, HUNDREDS; // output of bcd_to_7seg, input to led mux
wire DONT_USE, clk_5KHz, man_clk;

assign A_in_led = Ain;
assign B_in_led = Bin; 

clk_gen CLK (.clk100MHz(clk100MHz), .rst(rst), .clk_4sec(DONT_USE), .clk_5KHz(clk_5KHz));

button_debouncer D1 (.clk(clk_5KHz), .button(debounce), .debounced_button(man_clk));

mult_top_reg M1 (.A_top(Ain), .B_top(Bin), .clk(man_clk), .out_top(Total));

place_check P1 (.total(Total), .ones(ones), .tens(tens), .hundreds(hundreds));

bcd_to_7seg B1 (.BCD(ones), .s(ONES));
bcd_to_7seg B2 (.BCD(tens), .s(TENS));
bcd_to_7seg B3 (.BCD(hundreds), .s(HUNDREDS));

led_mux L1 (.clk(clk_5KHz), .rst(rst), 
            .LED0(ONES), .LED1(TENS), .LED2(HUNDREDS), .LED3(vcc), 
            .LED4(vcc), .LED5(vcc), .LED6(vcc), .LED7(vcc), 
            .LEDSEL(LEDSEL), .LEDOUT(LEDOUT));

endmodule
