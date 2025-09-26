/* 
--- File:    datapath.sv
--- Module:  datapath
--- Brief:   Baccarat datapath that draws cards, latches them, and drives seven-segment outputs.

--- Description:
---   Orchestrates card dealing and scoring. Receives load strobes from the control FSM and, on
---   the slow clock, captures dealt cards into player/dealer registers. The fast clock feeds
---   the card dealer. Registered card values are decoded to seven-segment displays and scored
---   via `scorehand`.

--- Interfaces:
---   Clocks/Reset:
---     slow_clock  : system tick for registers
---     fast_clock  : faster tick for RNG/dealer
---     resetb      : active-low reset (passed through to submodules)
---   Control:
---     load_*      : load strobes for each card register (player & dealer)
---   Status:
---     pcard3_out  : exposed player 3rd card (for controller logic, if needed)
---     pscore_out  : player total (0–9)
---     dscore_out  : dealer total (0–9)
---   Display:
---     HEX5..HEX0  : seven-segment encodings for D3 D2 D1 P3 P2 P1 (left→right)

--- Author: Joey Negm
*/

module datapath(
    input  logic       slow_clock, 
    input  logic       fast_clock, 
    input  logic       resetb,
    input  logic       load_pcard1, 
    input  logic       load_pcard2, 
    input  logic       load_pcard3,
    input  logic       load_dcard1, 
    input  logic       load_dcard2, 
    input  logic       load_dcard3,
    output logic [3:0] pcard3_out,
    output logic [3:0] pscore_out, 
    output logic [3:0] dscore_out,
    output logic [6:0] HEX5, 
    output logic [6:0] HEX4, 
    output logic [6:0] HEX3,
    output logic [6:0] HEX2, 
    output logic [6:0] HEX1, 
    output logic [6:0] HEX0
    );

    // --- Player and Dealer card registers ---
    logic [3:0] pcard1_out;
    logic [3:0] pcard2_out;

    logic [3:0] dcard1_out;
    logic [3:0] dcard2_out;
    logic [3:0] dcard3_out;

    // --- New card from dealer ---
    logic [3:0] new_card;

    // --- Instantiate registers/generator ---
    dealcard card_dealer(.clock(fast_clock),.resetb(resetb),.new_card(new_card));

    register PCARD1(.clk(slow_clock), .load(load_pcard1), .reset(resetb), .in(new_card), .out(pcard1_out));
    register PCARD2(.clk(slow_clock), .load(load_pcard2), .reset(resetb), .in(new_card), .out(pcard2_out));
    register PCARD3(.clk(slow_clock), .load(load_pcard3), .reset(resetb), .in(new_card), .out(pcard3_out));

    register DCARD1(.clk(slow_clock), .load(load_dcard1),.reset(resetb), .in(new_card), .out(dcard1_out));
    register DCARD2(.clk(slow_clock), .load(load_dcard2),.reset(resetb), .in(new_card), .out(dcard2_out));
    register DCARD3(.clk(slow_clock), .load(load_dcard3),.reset(resetb), .in(new_card), .out(dcard3_out));

    // --- Instantiate 7-seg decoders ---
    card7seg PCARD1_HEX0(.card(pcard1_out), .HEX(HEX0));
    card7seg PCARD2_HEX1(.card(pcard2_out), .HEX(HEX1));
    card7seg PCARD3_HEX2(.card(pcard3_out), .HEX(HEX2));

    card7seg DCARD1_HEX3(.card(dcard1_out), .HEX(HEX3));
    card7seg DCARD2_HEX4(.card(dcard2_out), .HEX(HEX4));
    card7seg DCARD3_HEX5(.card(dcard3_out), .HEX(HEX5));

    // --- Instantiate scoring modules ---
    scorehand PLAYER_SCORE(.card1(pcard1_out), .card2(pcard2_out), .card3(pcard3_out), .total(pscore_out));
    scorehand DEALER_SCORE(.card1(dcard1_out), .card2(dcard2_out), .card3(dcard3_out), .total(dscore_out));
endmodule

/* 
--- File:    register.sv
--- Module:  register
--- Brief:   4-bit load-enabled register with asynchronous active-low reset.

--- Description:
---   On the falling edge of clk, captures `in` when `load` is asserted; otherwise holds `out`.
---   Asynchronous active-low reset drives the register to zero.

--- Interfaces:
---   Inputs : clk, load, reset, in[3:0]
---   Outputs: out[3:0]
*/
module register(
    input  logic       clk, 
    input  logic       load, 
    input  logic       reset, 
    input  logic [3:0] in, 
    output logic [3:0] out
    );

    logic [3:0] next_out;

    // --- MUX for load enable ---
    assign next_out = load ? in : out;

    // --- Storage: sample on negedge, async reset ---
    always_ff @(negedge clk)begin
        if(reset === 1'd0)
            out <= 4'd0;
        else
            out <= next_out;
    end 
endmodule
