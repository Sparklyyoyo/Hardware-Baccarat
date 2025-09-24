/* Module that utilizes a seven segment display for "cards".
Has a card input and then displays card on HEX display according
to pre-defined shapes.*/

`define TWO   7'b0100100
`define THREE 7'b0110000
`define FOUR  7'b0011001
`define FIVE  7'b0010010
`define SIX   7'b0000010
`define SEVEN 7'b1111000
`define EIGHT 7'b0000000
`define NINE  7'b0010000
`define TEN 7'b1000000

`define ACE   7'b0001000
`define JACK  7'b1100001
`define QUEEN 7'b0011000
`define KING  7'b0001001

`define EMPTY 7'b1111111

module card7seg(input logic [3:0] card, output logic [6:0] HEX);

    // Contains case statement that decides card to display depending on input value.
    
    always_comb begin 

        case (card)

            4'd0: HEX = `EMPTY;
            4'd1: HEX = `ACE;
            4'd2: HEX = `TWO;
            4'd3: HEX = `THREE;
            4'd4: HEX = `FOUR;
            4'd5: HEX = `FIVE;
            4'd6: HEX = `SIX;
            4'd7: HEX = `SEVEN;
            4'd8: HEX = `EIGHT;
            4'd9: HEX = `NINE;
            4'd10: HEX = `TEN;
            4'd11: HEX = `JACK;
            4'd12: HEX = `QUEEN;
            4'd13: HEX = `KING;
            4'd14: HEX = `EMPTY;
            4'd15: HEX = `EMPTY;
            default: HEX = 7'bxxxxxxx;
    endcase
    end
endmodule

