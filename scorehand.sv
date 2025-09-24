/* Module that takes input cards and uses it to compute BACCARAT score.*/

module scorehand(input logic [3:0] card1, input logic [3:0] card2, input logic [3:0] card3, output logic [3:0] total);
    
    //Instantiating variables
    
    logic [4:0] SUM;
    logic [4:0] total_5bit;
    logic [3:0] internal_card1;
    logic [3:0] internal_card2;
    logic [3:0] internal_card3;

    //Always_block to decide score values depending on input.

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