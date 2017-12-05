#clock
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk100MHz }]; 
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk100MHz}];

#switch inputs
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { Ain[0] }]; #A input
set_property -dict { PACKAGE_PIN L16 IOSTANDARD LVCMOS33 } [get_ports { Ain[1] }]; 
set_property -dict { PACKAGE_PIN M13 IOSTANDARD LVCMOS33 } [get_ports { Ain[2] }]; 
set_property -dict { PACKAGE_PIN R15 IOSTANDARD LVCMOS33 } [get_ports { Ain[3] }]; 
set_property -dict { PACKAGE_PIN H6  IOSTANDARD LVCMOS33 } [get_ports { Bin[0] }]; #B input
set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports { Bin[1] }]; 
set_property -dict { PACKAGE_PIN U11 IOSTANDARD LVCMOS33 } [get_ports { Bin[2] }]; 
set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports { Bin[3] }]; 

#push buttons
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { rst }];
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { debounce }]; #manual clock control

#LED's
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { A_in_led[0] }]; #A LED
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { A_in_led[1] }]; 
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { A_in_led[2] }]; 
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { A_in_led[3] }]; 
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { B_in_led[0] }]; #B LED
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { B_in_led[1] }]; 
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { B_in_led[2] }]; 
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { B_in_led[3] }]; 

#7-segment disp
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[0] }]; 
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[1] }]; 
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[2] }]; 
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[3] }]; 
set_property -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[4] }]; 
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[5] }]; 
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[6] }]; 
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports { LEDOUT[7] }]; 

set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[0] }]; 
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[1] }]; 
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[2] }]; 
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[3] }]; 
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[4] }]; 
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[5] }]; 
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[6] }]; 
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { LEDSEL[7] }]; 