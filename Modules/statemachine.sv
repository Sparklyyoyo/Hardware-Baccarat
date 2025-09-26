/*
--- File:    statemachine.sv
--- Module:  statemachine
--- Brief:   Baccarat dealing state machine driving datapath load strobes and win lights.
---
--- Description:
---   Issues load strobes for player/dealer cards according to Baccarat rules:
---   initial two-card deal to player and dealer, optional third-card draws
---   based on player/dealer scores and the player's third card, then declares
---   the winner. Synchronous reset places the FSM at the first player deal.
---
--- Interfaces:
---   Clocks/Reset :
---     slow_clock      : system clock for the FSM
---     resetb          : active-low synchronous reset
---   Inputs       :
---     dscore, pscore  : current dealer/player totals (0–9)
---     pcard3          : player's third card value (0–13) when present
---   Outputs      :
---     load_*          : per-card load strobes for datapath registers
---     player_win_light, dealer_win_light : result indicator(s)
---
--- Author: Joey Negm
*/

 // --- State encoding ---
`define deal_pcard1 4'b0001
`define deal_pcard2 4'b0010
`define deal_pcard3 4'b0100

`define deal_dcard1 4'b1000
`define deal_dcard2 4'b0011
`define deal_dcard3 4'b0111

`define game_ends   4'b0000

module statemachine(input logic       slow_clock, 
                    input logic       resetb,

                    input logic [3:0] dscore, 
                    input logic [3:0] pscore, 
                    input logic [3:0] pcard3,

                    output logic      load_pcard1, 
                    output logic      load_pcard2, 
                    output logic      load_pcard3,

                    output logic      load_dcard1, 
                    output logic      load_dcard2, 
                    output logic      load_dcard3,

                    output logic      player_win_light, 
                    output logic      dealer_win_light);

    //--- FSM state ---
    logic [3:0] present_state;

    // --- Sequential logic to update state ---
    always_ff @(posedge slow_clock) begin
        if(~resetb)begin
            present_state = `deal_pcard1;
            
            load_pcard1 = 1'b1;
            load_pcard2 = 1'b0;
            load_pcard3 = 1'd0;

            load_dcard1 = 1'b0;
            load_dcard2 = 1'b0;
            load_dcard3 = 1'd0;

            player_win_light = 1'd0;
            dealer_win_light = 1'd0;
        end
        else begin
            // --- Next state logic (BACCARAT RULES) ---
            case(present_state)
                `deal_pcard1: present_state = `deal_dcard1;
                `deal_dcard1: present_state = `deal_pcard2;
                `deal_pcard2: present_state = `deal_dcard2;

                `deal_dcard2:begin
                    if(((pscore >= 4'd0) && (pscore <= 4'd5)) && ((dscore >= 4'd0) && (dscore <= 4'd7)))
                        present_state = `deal_pcard3;
                    else if(((pscore >= 4'd6) && (pscore <= 4'd7)) && ((dscore >= 4'd0) && (dscore <= 4'd5)))
                        present_state = `deal_dcard3;
                    else 
                        present_state = `game_ends;
                end

                `deal_pcard3: begin
                    if(((dscore === 4'd6) && ((pcard3 >= 4'd6) && (pcard3 <= 4'd7))) || ((dscore === 4'd5) && ((pcard3 >= 4'd4) && (pcard3 <= 4'd7))) || ((dscore === 4'd4) && ((pcard3 >= 4'd2) && (pcard3 <= 4'd7)))
                    || ((dscore === 4'd3) && (pcard3 !== 8)) || ((dscore >= 4'd0) && (dscore <= 4'd2)))
                        present_state = `deal_dcard3;
                    else
                        present_state = `game_ends;
                end

                `deal_dcard3: present_state = `game_ends;
                `game_ends:   present_state = `game_ends;
                default:      present_state = 4'bxxx;
            endcase

            // --- Output logic ---
            case(present_state)
                `deal_pcard1: begin
                    load_pcard1      = 1'b1;
                    load_pcard2      = 1'b0;
                    load_dcard1      = 1'b0;
                    load_dcard2      = 1'b0;
                    load_pcard3      = 1'd0;
                    load_dcard3      = 1'd0;
                    player_win_light = 1'd0;
                    dealer_win_light = 1'd0;
                end

                `deal_pcard2: begin
                    load_pcard1      = 1'b0;
                    load_pcard2      = 1'b1;
                    load_dcard1      = 1'b0;
                    load_dcard2      = 1'b0;
                    load_pcard3      = 1'd0;
                    load_dcard3      = 1'd0;
                    player_win_light = 1'd0;
                    dealer_win_light = 1'd0;
                end

                `deal_dcard1: begin
                    load_pcard1      = 1'b0;
                    load_pcard2      = 1'b0;
                    load_dcard1      = 1'b1;
                    load_dcard2      = 1'b0;
                    load_pcard3      = 1'd0;
                    load_dcard3      = 1'd0;
                    player_win_light = 1'd0;
                    dealer_win_light = 1'd0;
                end

                `deal_dcard2: begin
                    load_pcard1      = 1'b0;
                    load_pcard2      = 1'b0;
                    load_dcard1      = 1'b0;
                    load_dcard2      = 1'b1;
                    load_pcard3      = 1'd0;
                    load_dcard3      = 1'd0;
                    player_win_light = 1'd0;
                    dealer_win_light = 1'd0;
                end

                `deal_pcard3: begin
                    load_pcard1      = 1'b0;
                    load_pcard2      = 1'b0;
                    load_dcard1      = 1'b0;
                    load_dcard2      = 1'b0;
                    load_pcard3      = 1'd1;
                    load_dcard3      = 1'd0;
                    player_win_light = 1'd0;
                    dealer_win_light = 1'd0;
                end

                `deal_dcard3: begin
                    load_pcard1      = 1'b0;
                    load_pcard2      = 1'b0;
                    load_dcard1      = 1'b0;
                    load_dcard2      = 1'b0;
                    load_pcard3      = 1'd0;
                    load_dcard3      = 1'd1;
                    player_win_light = 1'd0;
                    dealer_win_light = 1'd0;
                end
                
                `game_ends: begin
                    load_pcard1 = 1'b0;
                    load_pcard2 = 1'b0;
                    load_dcard1 = 1'b0;
                    load_dcard2 = 1'b0;
                    load_pcard3 = 1'd0;
                    load_dcard3 = 1'd0;
                    
                    if(pscore > dscore)begin
                        player_win_light = 1'd1;
                        dealer_win_light = 1'd0;
                    end

                    else if(pscore < dscore)begin
                        player_win_light = 1'd0;
                        dealer_win_light = 1'd1;
                    end

                    else if(pscore === dscore) begin
                        player_win_light = 1'd1;
                        dealer_win_light = 1'd1;
                    end
                end
                
                default: begin
                    load_pcard1 = 1'bx;
                    load_pcard2 = 1'bx;
                    load_dcard1 = 1'bx;
                    load_dcard2 = 1'bx;
                    load_pcard3 = 1'bx;
                    load_dcard3 = 1'bx;
                end
            endcase
        end
    end
endmodule

