/*
-- File:    tb_statemachine.sv
-- Module:  tb_statemachine
-- Brief:   Self-checking testbench for the Baccarat dealing state machine.
--
-- Description:
--   Drives the statemachine through each path dictated by Baccarat rules and
--   checks the internal `present_state` against expected encodings. Keeps all
--   names and behavior intact; formatting and comments only.
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

`define deal_pcard1 4'b0001
`define deal_pcard2 4'b0010
`define deal_pcard3 4'b0100

`define deal_dcard1 4'b1000
`define deal_dcard2 4'b0011
`define deal_dcard3 4'b0111

`define game_ends   4'b0000

module tb_statemachine();

    // --- DUT I/O Signals ---
    logic       slow_clock;
    logic       resetb;
    logic [3:0] dscore;
    logic [3:0] pscore;
    logic [3:0] pcard3;

    logic       load_pcard1;
    logic       load_pcard2;
    logic       load_pcard3;
    logic       load_dcard1;
    logic       load_dcard2;
    logic       load_dcard3;
    logic       player_win_light;
    logic       dealer_win_light;
    logic       reset;
    logic       clk;

    // --- Connect DUT ---
    assign resetb = reset;
    assign slow_clock = clk;
    
    // --- Instantiate the DUT ---
    statemachine dut(.*);

    // --- Task to check expected vs actual state ---
    task check;
            input logic [3:0] expected_state;
            begin
                if(tb_statemachine.dut.present_state !== expected_state) begin
                    $error("Error: State is %b, Expected State is %b", tb_statemachine.dut.present_state,expected_state);
                end
            end
    endtask

    // --- Clock generation ---
    initial begin
        clk = 1'b0;
        #5;
        forever begin
            clk = 1'b1;
            #5;
            clk = 1'b0;
            #5;
        end  
    end

    // --- Test sequence ---
    initial begin
        reset = 1'b0;

        #10;
        $display("Testing reset state - deal_pcard1");
        check(`deal_pcard1);

        reset = 1'b1;
        #10
        $display("Testing deal_pcard1 TO deal_dcard1");
        check(`deal_dcard1);

        #10
        $display("Testing deal_dcard1 TO deal_pcard2");
        check(`deal_pcard2);
        
        #10
        $display("Testing deal_pcard2 TO deal_dcard2");
        check(`deal_dcard2);

        pscore = 5;
        dscore = 6;

        #10
        $display("Testing deal_dcard2 TO deal_pcard3");
        check(`deal_pcard3);

        pcard3 = 6;
        #10
        $display("Testing deal_pcard3 TO deal_dcard3");
        check(`deal_dcard3);

        #10
        $display("Testing deal_dcard3 TO game_ends");
        check(`game_ends);

        reset = 1'b0;
        #10;
        $display("Testing reset state - deal_pcard1");
        check(`deal_pcard1);

        reset = 1'b1;
        #10
        $display("Testing deal_pcard1 TO deal_dcard1");
        check(`deal_dcard1);

        #10
        $display("Testing deal_dcard1 TO deal_pcard2");
        check(`deal_pcard2);
        
        #10
        $display("Testing deal_pcard2 TO deal_dcard2");
        check(`deal_dcard2);

        pscore = 4;
        dscore = 5;

        #10
        $display("Testing deal_dcard2 TO deal_pcard3");
        check(`deal_pcard3);

        pcard3 = 4;
        #10
        $display("Testing deal_pcard3 TO deal_dcard3");
        check(`deal_dcard3);

        #10
        $display("Testing deal_dcard3 TO game_ends");
        check(`game_ends);

        reset = 1'b0;
        #10;
        $display("Testing reset state - deal_pcard1");
        check(`deal_pcard1);

        reset = 1'b1;
        #10
        $display("Testing deal_pcard1 TO deal_dcard1");
        check(`deal_dcard1);

        #10
        $display("Testing deal_dcard1 TO deal_pcard2");
        check(`deal_pcard2);
        
        #10
        $display("Testing deal_pcard2 TO deal_dcard2");
        check(`deal_dcard2);

        pscore = 3;
        dscore = 4;

        #10
        $display("Testing deal_dcard2 TO deal_pcard3");
        check(`deal_pcard3);

        pcard3 = 2;
        #10
        $display("Testing deal_pcard3 TO deal_dcard3");
        check(`deal_dcard3);

        #10
        $display("Testing deal_dcard3 TO game_ends");
        check(`game_ends);

        reset = 1'b0;
        #10;
        $display("Testing reset state - deal_pcard1");
        check(`deal_pcard1);

        reset = 1'b1;
        #10
        $display("Testing deal_pcard1 TO deal_dcard1");
        check(`deal_dcard1);

        #10
        $display("Testing deal_dcard1 TO deal_pcard2");
        check(`deal_pcard2);
        
        #10
        $display("Testing deal_pcard2 TO deal_dcard2");
        check(`deal_dcard2);

        pscore = 2;
        dscore = 3;

        #10
        $display("Testing deal_dcard2 TO deal_pcard3");
        check(`deal_pcard3);

        pcard3 = 1;
        #10
        $display("Testing deal_pcard3 TO deal_dcard3");
        check(`deal_dcard3);

        #10
        $display("Testing deal_dcard3 TO game_ends");
        check(`game_ends);

        reset = 1'b0;
        #10;
        $display("Testing reset state - deal_pcard1");
        check(`deal_pcard1);

        reset = 1'b1;
        #10
        $display("Testing deal_pcard1 TO deal_dcard1");
        check(`deal_dcard1);

        #10
        $display("Testing deal_dcard1 TO deal_pcard2");
        check(`deal_pcard2);
        
        #10
        $display("Testing deal_pcard2 TO deal_dcard2");
        check(`deal_dcard2);

        pscore = 0;
        dscore = 2;

        #10
        $display("Testing deal_dcard2 TO deal_pcard3");
        check(`deal_pcard3);

        pcard3 = 5;
        #10
        $display("Testing deal_pcard3 TO deal_dcard3");
        check(`deal_dcard3);

        #10
        $display("Testing deal_dcard3 TO game_ends");
        check(`game_ends);

        reset = 1'b0;
        #10;
        $display("Testing reset state - deal_pcard1");
        check(`deal_pcard1);

        reset = 1'b1;
        #10
        $display("Testing deal_pcard1 TO deal_dcard1");
        check(`deal_dcard1);

        #10
        $display("Testing deal_dcard1 TO deal_pcard2");
        check(`deal_pcard2);
        
        #10
        $display("Testing deal_pcard2 TO deal_dcard2");
        check(`deal_dcard2);

        pscore = 6;
        dscore = 3;

        #10
        $display("Testing deal_dcard2 TO deal_dcard3"); //Issue
        check(`deal_dcard3);
        
        #10
        $display("Testing deal_dcard3 TO game_ends");
        check(`game_ends);

        reset = 1'b0;
        #10;
        $display("Testing reset state - deal_pcard1");
        check(`deal_pcard1);

        reset = 1'b1;
        #10
        $display("Testing deal_pcard1 TO deal_dcard1");
        check(`deal_dcard1);

        #10
        $display("Testing deal_dcard1 TO deal_pcard2");
        check(`deal_pcard2);
        
        #10
        $display("Testing deal_pcard2 TO deal_dcard2");
        check(`deal_dcard2);

        pscore = 1;
        dscore = 7;

        #10
        $display("Testing deal_dcard2 TO deal_pcard3");
        check(`deal_pcard3);

        #10
        $display("Testing deal_pcard3 TO game_ends");
        check(`game_ends);

        reset = 1'b0;
        #10;
        $display("Testing reset state - deal_pcard1");
        check(`deal_pcard1);

        reset = 1'b1;
        #10
        $display("Testing deal_pcard1 TO deal_dcard1");
        check(`deal_dcard1);

        #10
        $display("Testing deal_dcard1 TO deal_pcard2");
        check(`deal_pcard2);
        
        #10
        $display("Testing deal_pcard2 TO deal_dcard2");
        check(`deal_dcard2);

        pscore = 8;
        dscore = 6;

        #10
        $display("Testing deal_dcard2 TO game_ends");
        check(`game_ends);

        reset = 1'b0;
        #10;
        $display("Testing reset state - deal_pcard1");
        check(`deal_pcard1);

        reset = 1'b1;
        #10
        $display("Testing deal_pcard1 TO deal_dcard1");
        check(`deal_dcard1);

        #10
        $display("Testing deal_dcard1 TO deal_pcard2");
        check(`deal_pcard2);
        
        #10
        $display("Testing deal_pcard2 TO deal_dcard2");
        check(`deal_dcard2);

        pscore = 7;
        dscore = 8;

        #10
        $display("Testing deal_dcard2 TO game_ends");
        check(`game_ends);

        reset = 1'b0;
        #10;
        $display("Testing reset state - deal_pcard1");
        check(`deal_pcard1);

        reset = 1'b1;
        #10
        $display("Testing deal_pcard1 TO deal_dcard1");
        check(`deal_dcard1);

        #10
        $display("Testing deal_dcard1 TO deal_pcard2");
        check(`deal_pcard2);
        
        #10
        $display("Testing deal_pcard2 TO deal_dcard2");
        check(`deal_dcard2);

        pscore = 8;
        dscore = 8;

        #10
        $display("Testing deal_dcard2 TO game_ends");
        check(`game_ends);

        $display("Purpose Fail for coverage");
        check(`deal_dcard1);

        $stop;
    end
endmodule


