/* 
--- File:    card7seg.sv
--- Module:  card7seg
--- Brief:   Seven-segment display driver for playing card values.

--- Description:
---   Converts a 4-bit card input into the appropriate 7-segment display pattern.
---   Supports displaying Ace through King, with blank display for invalid or empty inputs.

--- Interfaces:
---   Inputs : card [3:0]  - Encoded card value (0=empty, 1=Ace, 2–10=2–10, 11=Jack, 12=Queen, 13=King)
---   Outputs: HEX  [6:0]  - Seven-segment pattern to be driven to display

--- Author: Joey Negm
*/

// Seven-segment encoding for card values
`define TWO   7'b0100100
`define THREE 7'b0110000
`define FOUR  7'b0011001
`define FIVE  7'b0010010
`define SIX   7'b0000010
`define SEVEN 7'b1111000
`define EIGHT 7'b0000000
`define NINE  7'b0010000
`define TEN   7'b1000000

`define ACE   7'b0001000
`define JACK  7'b1100001
`define QUEEN 7'b0011000
`define KING  7'b0001001

`define EMPTY 7'b1111111


module card7seg(
    input  logic [3:0] card, 
    output logic [6:0] HEX
    );

    // Combinational logic to map card values to 7-segment patterns
    always_comb begin 
        case (card)
            4'd0: HEX    = `EMPTY;
            4'd1: HEX    = `ACE;
            4'd2: HEX    = `TWO;
            4'd3: HEX    = `THREE;
            4'd4: HEX    = `FOUR;
            4'd5: HEX    = `FIVE;
            4'd6: HEX    = `SIX;
            4'd7: HEX    = `SEVEN;
            4'd8: HEX    = `EIGHT;
            4'd9: HEX    = `NINE;
            4'd10: HEX   = `TEN;
            4'd11: HEX   = `JACK;
            4'd12: HEX   = `QUEEN;
            4'd13: HEX   = `KING;
            4'd14: HEX   = `EMPTY;
            4'd15: HEX   = `EMPTY;
            default: HEX = 7'bxxxxxxx;
    endcase
    end
endmodule

