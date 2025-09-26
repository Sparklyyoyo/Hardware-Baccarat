/* 
--- File:    scorehand.sv
--- Module:  scorehand
--- Brief:   Computes the Baccarat hand score given up to three cards.

--- Description:
---   Receives three 4-bit card values (0–13, where 10–13 represent face cards).
---   Face cards and tens are treated as zero. The sum of up to three cards is
---   computed, and the result is reduced modulo 10 (Baccarat rule) to produce
---   a final score between 0–9.

--- Interfaces:
---   Inputs :
---     card1, card2, card3 : card values
---   Outputs:
---     total               : hand score (0–9)

--- Author: Joey Negm
*/

module scorehand(
    input  logic [3:0] card1, 
    input  logic [3:0] card2, 
    input  logic [3:0] card3, 
    output logic [3:0] total
);

    //--- Internal signals ---
    logic [4:0] SUM;
    logic [4:0] total_5bit;
    logic [3:0] internal_card1;
    logic [3:0] internal_card2;
    logic [3:0] internal_card3;

    //--- Combinational logic to compute score ---
    always_comb begin
        if(card1 >= 4'd10)
            internal_card1 = 4'd0;
        else
            internal_card1 = card1;
        
        if(card2 >= 4'd10)
            internal_card2 = 4'd0;
        else
            internal_card2 = card2;

        if(card3 >= 4'd10)
            internal_card3 = 4'd0;
        else
            internal_card3 = card3;

        SUM = internal_card1 + internal_card2 + internal_card3;
        total_5bit = SUM % 5'd10;
        total = total_5bit[3:0];   
    end
endmodule