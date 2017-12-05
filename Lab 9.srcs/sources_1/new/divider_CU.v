`timescale 1ns / 1ps

module divider_CU(input Go, clk, reset,  //From outside
                  input R_lt_Y, divZ, //From DP
                  input [3:0] cnt_out,
                  output reg Done, Error,
                  output reg [3:0] State, Next_State,
                  output reg [12:0] ctrl_sig); // RMX1, RMX2, QMX, XMX______, R_LD, X_LD, Y_LD, R_SL, X_SL, R_SR, CNT_LD, CNT_CE, RST_DP
                  
// MUX R1 (input to shiftreg), R2 (output), Q (output), X
// R Load, shift left, shift right
// X load, shift left
// Y load
// Count LD and CE


parameter S0 = 4'b0000, //Idle
          S1 = 4'b0001, // Load R, X, Y, COUNT = 4
          S2 = 4'b0010, // Shift R and X
          S3 = 4'b0011, // Decrement COUNT
          S4 = 4'b0100, // set x-reg input bit to 1
          S5 = 4'b0101, // Restore & set quotient bit to 0
          S6 = 4'b0110, // Shift R left 1 bit
          S7 = 4'b0111, // Output quotient and remainder, Done flag
          ERROR = 4'b1000, // Y = 0, error, move to S0
          Ssub = 4'b1001, // subtraction between S3 and S4
          
                  //RMX1 RMX2 QMX XMX R_LD X_LD Y_LD R_SL X_SL R_SR CNT_LD CNT_CE RST_DP
          IDLE = 13'b__0____0___0___0____0____0____0____0____0____0______0______0______0,//  0  0  0000
          LOAD = 13'b__0____0___0___0____1____1____1____0____0____0______1______1______0,//  0  0  0001
          XRSL = 13'b__0____0___0___0____0____0____0____1____1____0______0______0______0,//  0  0  0010
          CNTD = 13'b__0____0___0___0____0____0____0____0____0____0______0______1______0,//  0  0  0011
          S4SL = 13'b__0____0___0___1____0____0____0____1____1____0______0______0______0,//  0  0  0100
          RLTY = 13'b__0____0___0___0____0____0____0____1____1____0______0______0______0,//  0  0  0101
          RSHR = 13'b__0____0___0___0____0____0____0____0____0____1______0______0______0,//  0  0  0110
          DONE = 13'b__0____1___1___0____0____0____0____0____0____0______0______0______0,//  1  0  0111
          ERR  = 13'b__0____0___0___0____0____0____0____0____0____0______0______0______1,//  0  1  1000
          SUBR = 13'b__1____0___0___0____1____0____0____0____0____0______0______0______0;//  0  0  1001
          


reg [3:0] CS = S0;
reg [3:0] NS;

//always @(posedge clk) // current state to next state block
//begin
//    CS <= NS; 
//end

always @(posedge clk, posedge reset) 
begin
    if (reset) CS <= S0;
    else CS <= NS; 
end

always @ (*) // Next state logic (CS, Go, divZ, R_lt_Y)
begin
    case(CS)
        S0: begin // idle at state 0 until go is received
                if (!Go) NS = S0;
                else NS = S1;
            end
        S1: NS = S2; // 
        S2: begin
                if(divZ) NS = ERROR;
                else NS = S3;
            end
        S3: begin // 
               if(R_lt_Y) NS = S5;
               else NS = Ssub;
            end
        Ssub: NS = S4;
        S4: begin // 
               if(cnt_out) NS = S6;
               else NS = S3;
            end
        S5: begin // 
               if(cnt_out) NS = S6;
               else NS = S3;
            end
        S6: NS = S7;
        S7: NS = S0;   
        ERROR: NS = S0; // state returns to state 0
    endcase
end

always @ (*) // output logic at each state
begin
Done = 1'b0;
Error = 1'b0;
    case(CS)
        S0:    begin ctrl_sig = IDLE; State = CS; end 
        S1:    begin ctrl_sig = LOAD; State = CS; end  
        S2:    begin ctrl_sig = XRSL; State = CS; end
        S3:    begin ctrl_sig = CNTD; State = CS; end  
        Ssub:  begin ctrl_sig = SUBR; State = CS; end
        S4:    begin ctrl_sig = S4SL; State = CS; end  
        S5:    begin ctrl_sig = RLTY; State = CS; end 
        S6:    begin ctrl_sig = RSHR; State = CS; end 
        S7:    begin ctrl_sig = DONE; Done = 1; State = CS; end
        ERROR: begin ctrl_sig = ERR; Error = 1; State = CS; end
    endcase
end

endmodule