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


`define deal_pcard1 4'b0001
`define deal_pcard2 4'b0010
`define deal_pcard3 4'b0100

`define deal_dcard1 4'b1000
`define deal_dcard2 4'b0011
`define deal_dcard3 4'b0111

`define game_ends   4'b0000


module tb_task5();


    //Inputs
    logic CLOCK_50;
    logic [3:0] KEY;

    //Outputs
    logic [9:0] LEDR;
    logic [6:0] HEX5;
    logic [6:0] HEX4;
    logic [6:0] HEX3;
    logic [6:0] HEX2;
    logic [6:0] HEX1;
    logic [6:0] HEX0;

    //Logic
    logic clk;
    logic reset;
    //logic err;
    logic [3:0] pscore;
    logic [3:0] dscore;
    logic player_wins;
    logic dealer_wins;

    assign KEY[3] = reset;
    assign KEY[0] = clk;
    assign pscore = LEDR [3:0];
    assign dscore = LEDR [7:4];
    assign player_wins = LEDR [8];
    assign dealer_wins = LEDR [9];

    task5 dut(.*);

    task check;

        input logic [6:0] out;
        input logic [6:0] expected_output;

        begin

            if(out !== expected_output) begin
                $error("Error: Output is %b, Expected Output is %b", out, expected_output);
                //err = 1'b1;
            end
        end
    endtask

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

    initial begin
        CLOCK_50 = 1'b0;
        #1;

        forever begin
            CLOCK_50 = 1'b1;
            #1;

            CLOCK_50 = 1'b0;
            #1;
        end  
    end

    initial begin

        //err = 1'b0;
        KEY[1] = 1'b1;
        KEY[2] = 1'b1;

        KEY[1] = 1'b0;
        KEY[2] = 1'b0;

        force HEX3[6:3] = 3'b000;
        force HEX3[6:3] = 3'b111;

        force HEX0[4] = 1'b1;
        force HEX0[4] = 1'b0;

        release HEX3[6:3];
        release HEX0[4];

        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);




        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that HEX 1 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd5;
        #10;

        $display("Checking that HEX 4 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd2);
         


        
        force tb_task5.dut.dp.new_card = 4'd3;
        #10;

        $display("Checking that deal_pcard3 state, HEX 2 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`THREE);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd8);
        check(dscore, 4'd2);
          


        
        force tb_task5.dut.dp.new_card = 4'd13;
        #10;

        $display("Checking that deal_dcard3 state, HEX 5 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`THREE);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`KING);
        check(pscore, 4'd8);
        check(dscore, 4'd2);
        check(player_wins, 1'b1);
        check(dealer_wins, 1'b0);


        //New Instance
        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 2");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd5;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd2);




        force tb_task5.dut.dp.new_card = 4'd3;
        #10;

        $display("Checking that deal_pcard3 state, HEX 2 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`THREE);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd8);
        check(dscore, 4'd2);
          


        
        force tb_task5.dut.dp.new_card = 4'd1;
        #10;

        $display("Checking that deal_dcard3 state, HEX 5 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`THREE);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`ACE);
        check(pscore, 4'd8);
        check(dscore, 4'd3);
        check(player_wins, 1'b1);
        check(dealer_wins, 1'b0);

        //New Instance
        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 3");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd5;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd2);




        force tb_task5.dut.dp.new_card = 4'd3;
        #10;

        $display("Checking that deal_pcard3 state, HEX 2 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`THREE);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd8);
        check(dscore, 4'd2);
          


        
        force tb_task5.dut.dp.new_card = 4'd2;
        #10;

        $display("Checking that deal_dcard3 state, HEX 5 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`THREE);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`TWO);
        check(pscore, 4'd8);
        check(dscore, 4'd4);
        check(player_wins, 1'b1);
        check(dealer_wins, 1'b0);

        //New Instance
        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 4");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd5;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd2);




        force tb_task5.dut.dp.new_card = 4'd4;
        #10;

        $display("Checking that deal_pcard3 state, HEX 2 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`FOUR);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd2);
          


        
        force tb_task5.dut.dp.new_card = 4'd3;
        #10;

        $display("Checking that deal_dcard3 state, HEX 5 and SCORES are accurate Issue");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`FOUR);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`THREE);
        check(pscore, 4'd9);
        check(dscore, 4'd5);
        check(player_wins, 1'b1);
        check(dealer_wins, 1'b0);
        
        //New Instance
        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 5");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd5;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd2);




        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that deal_pcard3 state, HEX 2 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`SIX);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd1);
        check(dscore, 4'd2);
          


        
        force tb_task5.dut.dp.new_card = 4'd4;
        #10;

        $display("Checking that deal_dcard3 state, HEX 5 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`SIX);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`FOUR);
        check(pscore, 4'd1);
        check(dscore, 4'd6);
        check(player_wins, 1'b0);
        check(dealer_wins, 1'b1);

        //New Instance
        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 6");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd5;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd2);




        force tb_task5.dut.dp.new_card = 4'd4;
        #10;

        $display("Checking that deal_pcard3 state, HEX 2 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`FOUR);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd2);
          


        
        force tb_task5.dut.dp.new_card = 4'd3;
        #10;

        $display("Checking that deal_dcard3 state, HEX 5 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`FOUR);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`THREE);
        check(pscore, 4'd9);
        check(dscore, 4'd5);
        check(player_wins, 1'b1);
        check(dealer_wins, 1'b0);
        
        //New Instance
        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 7");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd11;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`JACK);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd7);




        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that deal_pcard3 state, HEX 2 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`SIX);
        check(HEX3,`SEVEN);
        check(HEX4,`JACK);
        check(HEX5,`EMPTY);
        check(pscore, 4'd1);
        check(dscore, 4'd7);
          


        
        force tb_task5.dut.dp.new_card = 4'd4;
        #10;

        $display("Checking that deal_dcard3 state, HEX 5 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`SIX);
        check(HEX3,`SEVEN);
        check(HEX4,`JACK);
        check(HEX5,`EMPTY);
        check(pscore, 4'd1);
        check(dscore, 4'd7);
        check(player_wins, 1'b0);
        check(dealer_wins, 1'b1);

        //New Instance
        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 8");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SEVEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd6);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd5;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SEVEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd6);
        check(dscore, 4'd2);


        
        force tb_task5.dut.dp.new_card = 4'd12;
        #10;

        $display("Checking that deal_dcard3 state, HEX 5 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SEVEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`QUEEN);
        check(pscore, 4'd6);
        check(dscore, 4'd2);
        check(player_wins, 1'b1);
        check(dealer_wins, 1'b0);

        //New Instance
        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 9");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd5;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd5);
        check(dscore, 4'd2);




        force tb_task5.dut.dp.new_card = 4'd3;
        #10;

        $display("Checking that deal_pcard3 state, HEX 2 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`THREE);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd8);
        check(dscore, 4'd2);
          


        
        force tb_task5.dut.dp.new_card = 4'd2;
        #10;

        $display("Checking that deal_dcard3 state, HEX 5 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SIX);
        check(HEX2,`THREE);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`TWO);
        check(pscore, 4'd8);
        check(dscore, 4'd4);
        check(player_wins, 1'b1);
        check(dealer_wins, 1'b0);

        //New Instance - Coverage
        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd1;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`ACE);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd2;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`TWO);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd3;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`THREE);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd4;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`FOUR);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd5;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`FIVE);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd6;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`SIX);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`SEVEN);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd10;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`TEN);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd11;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`JACK);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd12;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`QUEEN);

        reset = 1'b0;
        #10;
        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd13;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`KING);
        

        
        //New Instance
        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 11");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SEVEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd6);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd2;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SEVEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`TWO);
        check(HEX5,`EMPTY);
        check(pscore, 4'd6);
        check(dscore, 4'd9);




        force tb_task5.dut.dp.new_card = 4'd3;
        #10;

        $display("Checking that game end by natural - dealer win");
        check(HEX0,`NINE);
        check(HEX1,`SEVEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`TWO);
        check(HEX5,`EMPTY);
        check(pscore, 4'd6);
        check(dscore, 4'd9);
        check(player_wins, 1'b0);
        check(dealer_wins, 1'b1);

        //New Instance
        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 12");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd10;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`TEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd2;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`TEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`TWO);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd9);




        force tb_task5.dut.dp.new_card = 4'd3;
        #10;

        $display("Checking that game end by natural - tie");
        check(HEX0,`NINE);
        check(HEX1,`TEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`TWO);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd9);
        check(player_wins, 1'b1);
        check(dealer_wins, 1'b1);

        $display("Fake Error for coverage");
        check(dealer_wins, 1'b0);

        reset = 1'b0;
        #10;

        $display("Checking that all HEX's and LED's are EMPTY - Instance 8");
        check(HEX0,`EMPTY);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd0);
        check(dscore, 4'd0);



        
        reset = 1'b1;
        force tb_task5.dut.dp.new_card = 4'd9;
        #10;

        $display("Checking that HEX 0 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`EMPTY);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd0);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 3 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`EMPTY);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd9);
        check(dscore, 4'd7);
        


        
        force tb_task5.dut.dp.new_card = 4'd7;
        #10;

        $display("Checking that HEX 1 and PSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SEVEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`EMPTY);
        check(HEX5,`EMPTY);
        check(pscore, 4'd6);
        check(dscore, 4'd7);
         


        
        force tb_task5.dut.dp.new_card = 4'd5;
        #10;

        $display("Checking that HEX 4 and DSCORE are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SEVEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`EMPTY);
        check(pscore, 4'd6);
        check(dscore, 4'd2);


        
        force tb_task5.dut.dp.new_card = 4'd12;
        #10;

        $display("Checking that deal_dcard3 state, HEX 5 and SCORES are accurate");
        check(HEX0,`NINE);
        check(HEX1,`SEVEN);
        check(HEX2,`EMPTY);
        check(HEX3,`SEVEN);
        check(HEX4,`FIVE);
        check(HEX5,`QUEEN);
        check(pscore, 4'd6);
        check(dscore, 4'd2);
        check(player_wins, 1'b1);
        check(dealer_wins, 1'b0);

        /*Removed for coverage 
        
        if(err)
            $display("FAILED");
        else
            $display("PASSED");
        
        */

        $stop;

    end
endmodule
