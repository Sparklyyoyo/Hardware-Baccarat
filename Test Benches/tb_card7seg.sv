/*
--- File:    tb_card7seg.sv
--- Module:  tb_card7seg
--- Brief:   Self-checking testbench for the card7seg decoder.
---
--- Description:
---   Drives all 16 possible 4-bit card values (0–15) and checks the
---   corresponding 7-seg patterns against the expected macros. Exercises
---   face cards, digits 0–9, and the EMPTY mapping for 14 and 15.
---
--- Notes:
---   • No functional changes to DUT; this bench only formats and asserts.
---   • Uses simple #10 delays between vector changes for readability.
---
--- Author: Joey Negm
*/

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

module tb_card7seg();

    // --- DUT I/O Signals ---
    logic [3:0] card;
    logic [6:0] HEX;

    // --- Instantiate the DUT ---
    card7seg dut(.*);

    initial begin
        card = 4'd0;
        #10;
        assert (HEX === `EMPTY) 
            $display("ZERO is Correct");
        else   
            $error("ZERO is Incorrect");
        
        card = 4'd1;
        #10;
        assert (HEX === `ACE)
            $display("ACE is Correct");
        else   
            $error("ACE is Incorrect");

        card = 4'd2;
        #10;
        assert (HEX === `TWO)
            $display("TWO is Correct");
        else   
            $error("TWO is Incorrect");

        card = 4'd3;
        #10;
        assert (HEX === `THREE)
            $display("THREE is Correct");
        else   
            $error("THREE is Incorrect");

        card = 4'd4;
        #10;
        assert (HEX === `FOUR)
            $display("FOUR is Correct");
        else   
            $error("FOUR is Incorrect");

        card = 4'd5;
        #10;
        assert (HEX === `FIVE)
            $display("FIVE is Correct");
        else   
            $error("FIVE is Incorrect");

        card = 4'd6;
        #10;
        assert (HEX === `SIX)
            $display("SIX is Correct");
        else   
            $error("SIX is Incorrect");
        
        card = 4'd7;
        #10;
        assert (HEX === `SEVEN)
            $display("SEVEN is Correct");
        else   
            $error("SEVEN is Incorrect");

        card = 4'd8;
        #10;
        assert (HEX === `EIGHT)
            $display("EIGHT is Correct");
        else   
            $error("EIGHT is Incorrect");

        card = 4'd9;
        #10;
        assert (HEX === `NINE)
            $display("NINE is Correct");
        else   
            $error("NINE is Incorrect");

        card = 4'd10;
        #10;
        assert (HEX === `TEN)
            $display("TEN is Correct");
        else   
            $error("TEN is Incorrect");

        card = 4'd11;
        #10;
        assert (HEX === `JACK)
            $display("JACK is Correct");
        else   
            $error("JACK is Incorrect");

        card = 4'd12;
        #10;
        assert (HEX === `QUEEN)
            $display("QUEEN is Correct");
        else   
            $error("QUEEN is Incorrect");

        card = 4'd13;
        #10;
        assert (HEX === `KING)
            $display("KING is Correct");
        else   
            $error("KING is Incorrect");

        card = 4'd14;
        #10;
        assert (HEX === `EMPTY)
            $display("FOURTEEN is Correct");
        else   
            $error("FOURTEEN is Incorrect");

        card = 4'd15;
        #10;
        assert (HEX === `EMPTY)
            $display("FIFTEEN is Correct");
        else   
            $error("FIFTEEN is Incorrect");
    end
endmodule

