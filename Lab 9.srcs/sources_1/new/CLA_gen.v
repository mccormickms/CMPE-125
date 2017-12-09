`timescale 1ns / 1ps

module CLA_gen(input C_IN,           // carry bit into gen not from adders
                     P0, P1, P2, P3, // sum bit from each half adder
                     G0, G1, G2, G3, // carry bit from each half adder
              output reg C0, C1, C2, C3, C4); // carry bit outputs
              
always @ (*)
begin
    C0 = C_IN; // first carry in bit 
    C1 = G0 | (P0 & C_IN); 
    C2 = G1 | (P1 & (G0 | (P0 & C_IN)));
    C3 = G2 | (P2 & (G1 | (P1 & (G0 | (P0 & C_IN))))); 
    C4 = G3 | (P3 & (G2 | (P2 & (G1 | (P1 & (G0 | (P0 & C_IN)))))));
end
endmodule
