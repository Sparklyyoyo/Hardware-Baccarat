/* Datapath module that contains all logic of the system. Takes clocks, reset,
and load values from state machine to perform it's function. Uses input
from state machine, card_dealer, and scorehand to compute and display cards for
the baccarat game */

module datapath(input logic slow_clock, input logic fast_clock, input logic resetb,
                input logic load_pcard1, input logic load_pcard2, input logic load_pcard3,
                input logic load_dcard1, input logic load_dcard2, input logic load_dcard3,
                output logic [3:0] pcard3_out,
                output logic [3:0] pscore_out, output logic [3:0] dscore_out,
                output logic [6:0] HEX5, output logic [6:0] HEX4, output logic [6:0] HEX3,
                output logic [6:0] HEX2, output logic [6:0] HEX1, output logic [6:0] HEX0);

    //Initializing variables
    logic [3:0] pcard1_out;
    logic [3:0] pcard2_out;

    logic [3:0] dcard1_out;
    logic [3:0] dcard2_out;
    logic [3:0] dcard3_out;
    logic [3:0] new_card;

    //Instantiating relevent modules
    dealcard card_dealer(.clock(fast_clock),.resetb(resetb),.new_card(new_card));

    register PCARD1(.clk(slow_clock), .load(load_pcard1), .reset(resetb), .in(new_card), .out(pcard1_out));
    register PCARD2(.clk(slow_clock), .load(load_pcard2), .reset(resetb), .in(new_card), .out(pcard2_out));
    register PCARD3(.clk(slow_clock), .load(load_pcard3), .reset(resetb), .in(new_card), .out(pcard3_out));

    register DCARD1(.clk(slow_clock), .load(load_dcard1),.reset(resetb), .in(new_card), .out(dcard1_out));
    register DCARD2(.clk(slow_clock), .load(load_dcard2),.reset(resetb), .in(new_card), .out(dcard2_out));
    register DCARD3(.clk(slow_clock), .load(load_dcard3),.reset(resetb), .in(new_card), .out(dcard3_out));

    card7seg PCARD1_HEX0(.card(pcard1_out), .HEX(HEX0));
    card7seg PCARD2_HEX1(.card(pcard2_out), .HEX(HEX1));
    card7seg PCARD3_HEX2(.card(pcard3_out), .HEX(HEX2));

    card7seg DCARD1_HEX3(.card(dcard1_out), .HEX(HEX3));
    card7seg DCARD2_HEX4(.card(dcard2_out), .HEX(HEX4));
    card7seg DCARD3_HEX5(.card(dcard3_out), .HEX(HEX5));

    scorehand PLAYER_SCORE(.card1(pcard1_out), .card2(pcard2_out), .card3(pcard3_out), .total(pscore_out));
    scorehand DEALER_SCORE(.card1(dcard1_out), .card2(dcard2_out), .card3(dcard3_out), .total(dscore_out));
endmodule

module register(input logic clk, input logic load, input logic reset, input logic [3:0] in, output logic [3:0] out); //Register with load value module. Only rewrites value when load is 1 and on rising edge of the clock.

    logic [3:0] next_out;

    assign next_out = load ? in : out;

    //Flip_flop block that works on negedge to quickly follow up with state changes

    always_ff @(negedge clk)begin
        if(reset === 1'd0)
            out <= 3'd0;

        else
            out <= next_out;
    end 
endmodule
